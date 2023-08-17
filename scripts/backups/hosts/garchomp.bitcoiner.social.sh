#!/bin/bash
set -x
TARGET=$(basename -- "$0" .sh)

source ../functions.sh
BACKUP_MAIL

rsync -tav --exclude venv --exclude plugin.log --exclude data.mdb root@${TARGET}:/var/lib/strfry $HOME/archive/${TARGET}/
rsync -tav root@${TARGET}:/var/www/static/attachments $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/