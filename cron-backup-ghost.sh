#!/bin/bash

DIR="/home/piotr/ghost"
BACKUP_SCRIPT="${DIR}/backup.sh"
BACKUP_DIR=/home/piotr/ghost-backup/

BACKUP_RETENTION_PERIOD=120
LOG_FILE=/var/log/backup-ghost.log

DATE=$(date '+%Y/%m/%Y-%m-%d-%H-%S')

# Make backup directory
mkdir -p ${BACKUP_DIR}

echo "${DATE} - Running ghost backup" >> $LOG_FILE
cd "${DIR}" || echo "${DATE} - Error: can't cd into ${DIR}" >> $LOG_FILE

"${BACKUP_SCRIPT}"

echo "${DATE} - Moving backup to ${BACKUP_DIR} " >> $LOG_FILE
mv ./*.tar.gz ${BACKUP_DIR}

echo "${DATE} - Pruning backups older than ${BACKUP_RETENTION_PERIOD} " >> $LOG_FILE
find "$BACKUP_DIR" -type f -mtime $BACKUP_RETENTION_PERIOD -iname '*.tar.gz' -delete
echo "${DATE} - Backup directory pruned" >> $LOG_FILE