FROM amazon/aws-cli:2.15.35
LABEL Author="Luca Mattivi <luca@smartdomotik.com>"

RUN yum update -y && yum install tar gzip -y

ENV BACKUP_TGT_DIR=/backup/
ENV BACKUP_SRC_DIR=/data/
ENV BACKUP_FILE_NAME='backup'

# bucket/path/to/place/
ENV BACKUP_S3_BUCKET=
ENV AWS_DEFAULT_REGION=
ENV AWS_ACCESS_KEY_ID=
ENV AWS_SECRET_ACCESS_KEY=

ADD backup.sh /opt/backup.sh
ADD restore.sh /opt/restore.sh
RUN chmod +x /opt/*.sh

VOLUME $BACKUP_TGT_DIR
VOLUME $BACKUP_SRC_DIR

WORKDIR /opt/

ENTRYPOINT ["/opt/backup.sh"]
