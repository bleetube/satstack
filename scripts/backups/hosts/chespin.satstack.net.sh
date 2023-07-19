#!/bin/bash
set -e
set -x
TARGET=wartortle.satstack.net
TIMESTAMP=$(date +%m-%d-%Y)

# nixbitcoin
rsync -ta root@${TARGET}:/var/lib/localBackups $HOME/archive/${TARGET}/