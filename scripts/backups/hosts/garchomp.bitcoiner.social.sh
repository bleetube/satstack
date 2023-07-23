#!/bin/bash
set -e
set -x
TARGET=garchomp.bitcoiner.social

source ../functions.sh
BACKUP_DOVECOT_IMAP

rsync -tav root@${TARGET}:/var/www/static/attachments $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/