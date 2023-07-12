#!/bin/bash
TARGET=shinx.charlgiwnbro.com
rsync -tv root@${TARGET}:/etc/wireguard/zorua.conf $HOME/archive/${TARGET}/
