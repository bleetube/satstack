#!/bin/bash
set -x
TARGET=$(basename -- "$0" .sh)

source "$(dirname "$0")/../functions.sh"
BACKUP_MAIL
BACKUP_PG_DB synapse

# matrix-synapse
rsync -ta root@${TARGET}:/etc/matrix-synapse $HOME/archive/${TARGET}/matrix-synapse/config
rsync -ta root@${TARGET}:/var/lib/matrix-synapse/media $HOME/archive/${TARGET}/matrix-synapse/media

# iptables
rsync -ta root@${TARGET}:/etc/iptables.rules $HOME/archive/${TARGET}/

# tor
mkdir -p $HOME/archive/${TARGET}/tor
rsync -ta root@${TARGET}:/etc/tor/torrc $HOME/archive/${TARGET}/tor

du -sh $HOME/archive/${TARGET}/