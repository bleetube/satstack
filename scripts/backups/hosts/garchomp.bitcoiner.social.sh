#!/bin/bash
TARGET=garchomp.bitcoiner.social
rsync -tav root@${TARGET}:/var/www/static/attachments $HOME/archive/garchomp.bitcoiner.social/
