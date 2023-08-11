#!/bin/bash

TARGET=metagross.bitcoiner.social

source ../functions.sh
BACKUP_MAIL

rsync -taP --exclude .venv --exclude plugin.log --exclude data.mdb root@${TARGET}:/opt/strfry $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/