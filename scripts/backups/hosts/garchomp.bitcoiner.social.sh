#!/bin/bash
set -x
TARGET=garchomp.bitcoiner.social

#BACKUP_DOVECOT_IMAP

rsync -tav root@${TARGET}:/var/www/static/attachments $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/