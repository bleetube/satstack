#!/bin/bash
set -x
TARGET=garchomp.bitcoiner.social

BACKUP_PG_DB nostream

rsync -tav root@${TARGET}:/var/www/static/attachments $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/