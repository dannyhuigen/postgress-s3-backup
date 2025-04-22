FROM amazonlinux:2

RUN yum install -y postgresql15 awscli cronie gzip

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

# Entrypoint script to set up cron with custom schedule
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]