#!/bin/sh
set -e

# Default schedule if not set
SCHEDULE="${SCHEDULE:-0 2 * * *}"

# Write out the cron job
echo "$SCHEDULE /usr/local/bin/backup.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/pg_backup
chmod 0644 /etc/cron.d/pg_backup
crontab /etc/cron.d/pg_backup

# Create the log file if it doesn't exist
touch /var/log/cron.log

# Start cron in the background
cron

# Tail the log file to stdout
tail -F /var/log/cron.log
