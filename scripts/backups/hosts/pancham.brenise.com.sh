#!/bin/bash
set -e
set -x
TARGET=pancham.brenise.com
TIMESTAMP=$(date +%m-%d-%Y)

source ../functions.sh
BACKUP_MAIL
BACKUP_PG_DB synapse
BACKUP_PG_DB peertube
BACKUP_PG_DB tandoor

# matrix-synapse
rsync -ta root@${TARGET}:/etc/matrix-synapse $HOME/archive/${TARGET}/matrix-synapse/config
rsync -ta root@${TARGET}:/var/lib/matrix-synapse/media $HOME/archive/${TARGET}/matrix-synapse/media

du -sh $HOME/archive/${TARGET}/