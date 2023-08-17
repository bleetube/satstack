#!/bin/bash
set -x
TARGET=$(basename -- "$0" .sh)
TIMESTAMP=$(date +%m-%d-%Y)

rsync -taP --exclude archive root@${TARGET}:/etc/nginx $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/
