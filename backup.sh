#!/bin/bash

COMPARE_DIR="/compare_dir/"

echo "backup started at $(date +%Y-%m-%d_%H:%M:%S)"

echo "creating archive..."

# this has to be executed like this, because we have two level expansion in variables
eval "export BACKUP_DST_FULL_PATH=${BACKUP_TGT_DIR}${BACKUP_FILE_NAME}.tar.gz"
eval "export COMPARE_DST_FULL_PATH=${COMPARE_DIR}${BACKUP_FILE_NAME}.tar.gz"

BACKUP_DST_DIR=$(dirname "${BACKUP_DST_FULL_PATH}")

mkdir -p ${COMPARE_DIR}
echo "Gzipping ${BACKUP_SRC_DIR} into ${COMPARE_DST_FULL_PATH}"
tar -czf ${COMPARE_DST_FULL_PATH} --exclude-tag-all=exclude_dir_from_backup -C ${BACKUP_SRC_DIR} .

if cmp -s -i 8 "$BACKUP_DST_FULL_PATH" "$COMPARE_DST_FULL_PATH"
then
   echo "Archive is the same of the old one, do nothing."
else
   echo "Archive is different from the old one, uploading to s3..."
   mkdir -p ${BACKUP_DST_DIR}
   mv "$COMPARE_DST_FULL_PATH" "$BACKUP_DST_FULL_PATH"
   #echo "archive created, uploading..."
   /usr/local/bin/aws s3 sync ${BACKUP_TGT_DIR} s3://${BACKUP_S3_BUCKET} --region ${AWS_DEFAULT_REGION}
fi


echo "backup finished at $(date +%Y-%m-%d_%H:%M:%S)"
