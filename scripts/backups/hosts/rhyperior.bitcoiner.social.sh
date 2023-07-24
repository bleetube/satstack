#!/bin/bash
set -e
set -x
TARGET=rhyperior.bitcoiner.social
TIMESTAMP=$(date +%m-%d-%Y)

source ../functions.sh
#BACKUP_PG_DB hedgedoc
#BACKUP_PG_DB synapse
BACKUP_MARIADB castopod

# castopod
mkdir -p $HOME/archive/${TARGET}/castopod/public/media
rsync -ta root@${TARGET}:/var/compose/castopod/public/media $HOME/archive/${TARGET}/castopod/public/media

# Restoring castopod:
#rsync -ta $HOME/archive/${TARGET}/castopod/public/media/persons rhyperior:/var/compose/castopod/public/media/
#rsync -ta $HOME/archive/${TARGET}/castopod/public/media/podcasts rhyperior:/var/compose/castopod/public/media/
# on the target, drop and recreate an empty database. Then:
#doas -u mysql bzcat /tmp/castopod_*.dump.bz2 | mysql -uroot

du -sh $HOME/archive/${TARGET}/