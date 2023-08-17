#!/bin/bash
set -x
TARGET=$(basename -- "$0" .sh)
TIMESTAMP=$(date +%m-%d-%Y)

source ../functions.sh

#BACKUP_PG_DB miniflux

# nixbitcoin
rsync -ta root@${TARGET}:/var/lib/localBackups $HOME/archive/${TARGET}/

# vaultwarden
rsync -ta root@${TARGET}:/var/lib/vaultwarden/backups/ $HOME/archive/${TARGET}/vaultwarden/