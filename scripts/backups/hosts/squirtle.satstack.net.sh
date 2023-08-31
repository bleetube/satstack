#!/bin/bash
set -x
TARGET=$(basename -- "$0" .sh)
TIMESTAMP=$(date +%m-%d-%Y)

rsync -taP --exclude archive root@${TARGET}:/etc/nginx $HOME/archive/${TARGET}/

# lnd
mkdir -p $HOME/archive/${TARGET}/lnd/
rsync -taP --exclude archive root@${TARGET}:/var/lib/lnd/lnd.conf $HOME/archive/${TARGET}/lnd/

du -sh $HOME/archive/${TARGET}/
