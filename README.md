# postgress-s3-backup

## A simple postgres dumper and uploader to S3

- Secrets are read from files for security.
- Schedule is fully configurable.
- Old backups are deleted from S3 after the specified number of days.

Example docker swarm:
```yaml

services:
  pg_backup:
    image: dannyhuigen1/postgress-s3-backup:latest
    environment:
      SCHEDULE: '0 0 4 * * *'
      BACKUP_KEEP_DAYS: 7
      S3_REGION: eu-central-1
      S3_BUCKET: primni-backup
      S3_PREFIX: backup
      POSTGRES_HOST: postgres
      POSTGRES_DATABASE: db
      S3_ACCESS_KEY_ID_FILE: /run/secrets/iam_s3_backup_username
      S3_SECRET_ACCESS_KEY_FILE: /run/secrets/iam_s3_backup_password
      POSTGRES_USER_FILE: /run/secrets/pg_user_username_main
      POSTGRES_PASSWORD_FILE: /run/secrets/pg_user_password_main
    secrets:
      - source: iam_s3_backup_username
        target: iam_s3_backup_username
      - source: iam_s3_backup_password
        target: iam_s3_backup_password
      - source: pg_user_username_main
        target: pg_user_username_main
      - source: pg_user_password_main
        target: pg_user_password_main
    deploy:
      placement:
        constraints: [node.role == manager]
        
secrets:
  iam_s3_backup_username:
    external: true
  iam_s3_backup_password:
    external: true
  pg_user_username_main:
    external: true
  pg_user_password_main:
    external: true


```