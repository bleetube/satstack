#!/bin/bash
set -x
TARGET=$(basename -- "$0" .sh)

source "$(dirname "$0")/../functions.sh"
BACKUP_MAIL

du -sh $HOME/archive/${TARGET}/