#!/bin/bash
set -e
set -x
TARGET=pancham.brenise.com
source ../functions.sh

BACKUP_MAIL

du -sh $HOME/archive/${TARGET}/