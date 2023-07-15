#!/bin/bash
TARGET=wartortle.satstack.net
TIMESTAMP=$(date +%m-%d-%Y)

rsync --delete-after -ta root@${TARGET}:/var/compose/changedetection $HOME/archive/${TARGET}/

# nextcloud
rsync --delete-after -ta ${TARGET}:/var/compose/nextcloud $HOME/archive/${TARGET}/

# postgresql: nextcloud
BACKUP_DIR=$HOME/archive/${TARGET}/postgresql
DUMP_FILE=/var/lib/postgresql/nextcloud_${TIMESTAMP}.dump.bz2
ssh root@${TARGET} "doas -u postgres /usr/bin/pg_dump -Fc nextcloud | /usr/bin/bzip2 > ${DUMP_FILE}"
mkdir -p $HOME/archive/${TARGET}/postgresql/
rsync -tav ${TARGET}:${DUMP_FILE} $HOME/archive/${TARGET}/postgresql/
ssh root@${TARGET} rm -v ${DUMP_FILE}

# Only remove older backups if newer backups exist
NEWER_BACKUPS=$(find $BACKUP_DIR -mtime -60 -type f -name '*.dump.bz2')
if [[ -n $NEWER_BACKUPS ]]; then
    find $BACKUP_DIR -mtime +60 -type f -name '*.dump.bz2' -delete
else
    echo "No newer backups found. Old backups not pruned."
fi

du -sh $HOME/archive/${TARGET}/