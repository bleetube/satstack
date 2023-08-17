#!/bin/bash
set -x
TARGET=$(basename -- "$0" .sh)

rsync -tv root@${TARGET}:/etc/wireguard/zorua.conf $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/