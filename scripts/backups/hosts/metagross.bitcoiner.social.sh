#!/bin/bash

TARGET=metagross.bitcoiner.social

rsync -taP --exclude .venv --exclude plugin.log --exclude data.mdb root@${TARGET}:/opt/strfry $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/