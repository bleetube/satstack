#!/bin/bash
set -x
TARGET=$(basename -- "$0" .sh)

source "$(dirname "$0")/../functions.sh"
BACKUP_MAIL
BACKUP_STRFRY_DB

rsync -taP --exclude .venv --exclude plugin.log --exclude data.mdb root@${TARGET}:/opt/strfry $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/