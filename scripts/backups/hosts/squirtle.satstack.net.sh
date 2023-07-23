#!/bin/bash
set -e
set -x
TARGET=squirtle.satstack.net
TIMESTAMP=$(date +%m-%d-%Y)

source ../functions.sh

BACKUP_PG_DB wikijs

du -sh $HOME/archive/${TARGET}/
