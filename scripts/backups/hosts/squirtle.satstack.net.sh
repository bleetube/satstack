#!/bin/bash
set -x
TARGET=$(basename -- "$0" .sh)
TIMESTAMP=$(date +%m-%d-%Y)

rsync -taP --exclude archive root@${TARGET}:/etc/nginx $HOME/archive/${TARGET}/

# lnd
mkdir -p $HOME/archive/${TARGET}/lnd/
rsync -tv root@${TARGET}:/var/lib/lnd/lnd.conf $HOME/archive/${TARGET}/lnd/

# satdress
rsync -taP --exclude archive root@${TARGET}:/var/lib/satdress $HOME/archive/${TARGET}/

# nostr-wallet-connect
rsync -taP --exclude archive root@${TARGET}:/var/lib/nwc $HOME/archive/${TARGET}/
rsync -tv root@${TARGET}:/etc/systemd/system/nwc.service $HOME/archive/${TARGET}/
rsync -tv root@${TARGET}:/etc/nginx/conf.d/nwc.conf $HOME/archive/${TARGET}/

# ln-ws-proxy
rsync -tv root@${TARGET}:/etc/systemd/system/ln-ws-proxy.service $HOME/archive/${TARGET}/
rsync -tv root@${TARGET}:/etc/nginx/conf.d/ln-ws-proxy.conf $HOME/archive/${TARGET}/

# systemd
mkdir -p $HOME/archive/${TARGET}/systemd/system
rsync -tv root@${TARGET}:/etc/systemd/system/backups.{service,timer} $HOME/archive/${TARGET}/systemd/system
rsync -tv root@${TARGET}:/etc/systemd/system/ansible-lego.{service,timer} $HOME/archive/${TARGET}/systemd/system

du -sh $HOME/archive/${TARGET}/
