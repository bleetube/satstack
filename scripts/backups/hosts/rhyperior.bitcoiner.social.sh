#!/bin/bash
set -x
TARGET=$(basename -- "$0" .sh)
TIMESTAMP=$(date +%m-%d-%Y)

source ../functions.sh

#BACKUP_PG_DB hedgedoc
BACKUP_PG_DB synapse
BACKUP_MARIADB castopod

# castopod
mkdir -p $HOME/archive/${TARGET}/castopod/public/media
rsync -ta root@${TARGET}:/var/compose/castopod/public/media $HOME/archive/${TARGET}/castopod/public/media

# matrix-synapse
rsync -ta root@${TARGET}:/etc/matrix-synapse $HOME/archive/${TARGET}/matrix-synapse/config
rsync -ta root@${TARGET}:/var/lib/matrix-synapse/media $HOME/archive/${TARGET}/matrix-synapse/media

du -sh $HOME/archive/${TARGET}/