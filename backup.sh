#!/bin/bash
set -e

# Read secrets from files
export POSTGRES_USER=$(cat "$POSTGRES_USER_FILE")
export POSTGRES_PASSWORD=$(cat "$POSTGRES_PASSWORD_FILE")
export AWS_ACCESS_KEY_ID=$(cat "$S3_ACCESS_KEY_ID_FILE")
export AWS_SECRET_ACCESS_KEY=$(cat "$S3_SECRET_ACCESS_KEY_FILE")

# Set AWS region
export AWS_DEFAULT_REGION="$S3_REGION"

# Date for backup file
DATE=$(date +%Y-%m-%d_%H-%M)
BACKUP_FILE="/tmp/pg_backup_$DATE.sql.gz"
S3_PATH="s3://$S3_BUCKET/$S3_PREFIX/pg_backup_$DATE.sql.gz"

# Dump the database
PGPASSWORD="$POSTGRES_PASSWORD" pg_dump -h "$POSTGRES_HOST" -U "$POSTGRES_USER" "$POSTGRES_DATABASE" | gzip > "$BACKUP_FILE"

# Upload to S3
aws s3 cp "$BACKUP_FILE" "$S3_PATH"

# Remove local backup
rm "$BACKUP_FILE"

# Delete old backups from S3
if [[ -n "$BACKUP_KEEP_DAYS" ]]; then
  # List objects, filter by prefix, and delete those older than BACKUP_KEEP_DAYS
  aws s3 ls "s3://$S3_BUCKET/$S3_PREFIX/" | \
    awk '{print $1, $2, $4}' | \
    while read -r file_date file_time file_name; do
      file_datetime="${file_date} ${file_time}"
      file_epoch=$(date -d "$file_datetime" +%s)
      cutoff_epoch=$(date -d "$BACKUP_KEEP_DAYS days ago" +%s)
      if [[ $file_epoch -lt $cutoff_epoch ]]; then
        aws s3 rm "s3://$S3_BUCKET/$S3_PREFIX/$file_name"
      fi
    done
fi
