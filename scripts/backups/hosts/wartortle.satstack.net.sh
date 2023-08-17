#!/bin/bash
set -e
set -x
TARGET=$(basename -- "$0" .sh)
TIMESTAMP=$(date +%m-%d-%Y)

source ../functions.sh
BACKUP_PG_DB wikijs
BACKUP_PG_DB nextcloud

# changedetection
rsync --delete-after -ta root@${TARGET}:/var/compose/changedetection $HOME/archive/${TARGET}/
# nextcloud
rsync --delete-after -ta root@${TARGET}:/var/compose/nextcloud $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/
