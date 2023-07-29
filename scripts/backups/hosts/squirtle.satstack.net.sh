#!/bin/bash
set -e
set -x
TARGET=squirtle.satstack.net
TIMESTAMP=$(date +%m-%d-%Y)

rsync -taP --exclude archive root@${TARGET}:/etc/nginx $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/
