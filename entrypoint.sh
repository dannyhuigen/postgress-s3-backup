#!/bin/bash
set -e

# Default schedule if not set
SCHEDULE="${SCHEDULE:-0 4 * * *}"

# Write out the cron job
echo "$SCHEDULE /usr/local/bin/backup.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/pg_backup
chmod 0644 /etc/cron.d/pg_backup
crontab /etc/cron.d/pg_backup

# Start cron in foreground
crond -f -L /var/log/cron.log