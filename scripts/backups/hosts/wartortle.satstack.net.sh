#!/bin/bash
TARGET=wartortle.satstack.net
rsync -tav root@${TARGET}:/var/compose/changedetection $HOME/archive/${TARGET}/
