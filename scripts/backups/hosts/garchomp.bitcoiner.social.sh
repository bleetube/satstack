#!/bin/bash
set -x
TARGET=garchomp.bitcoiner.social

source ../functions.sh
BACKUP_MAIL

rsync -tav --exclude venv --exclude plugin.log --exclude data.mdb root@${TARGET}:/var/lib/strfry $HOME/archive/${TARGET}/
rsync -tav root@${TARGET}:/var/www/static/attachments $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/