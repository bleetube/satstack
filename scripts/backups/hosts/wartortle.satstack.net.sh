#!/bin/bash
TARGET=wartortle.satstack.net

rsync -ta root@${TARGET}:/var/compose/changedetection $HOME/archive/${TARGET}/

du -sh $HOME/archive/${TARGET}/
