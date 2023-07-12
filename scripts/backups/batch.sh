#!/bin/bash
HOSTS=(
    garchomp.bitcoiner.social
    shinx.charlgiwnbro.com
    wartortle.satstack.net
)
for host in ${HOSTS[@]}; do
    exec hosts/${hostname}.sh
done

du -sh $HOME/archive