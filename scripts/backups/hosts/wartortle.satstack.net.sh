#!/bin/bash
set -e
set -x
TARGET=wartortle.satstack.net
TIMESTAMP=$(date +%m-%d-%Y)

# changedetection
rsync --delete-after -ta root@${TARGET}:/var/compose/changedetection $HOME/archive/${TARGET}/
# nextcloud
rsync --delete-after -ta root@${TARGET}:/var/compose/nextcloud $HOME/archive/${TARGET}/
BACKUP_PG_DB nextcloud

# wikijs
BACKUP_PG_DB wikijs

du -sh $HOME/archive/${TARGET}/
