#!/bin/bash
HOSTS=(
    garchomp.bitcoiner.social
    metagross.bitcoiner.social
    rhyperior.bitcoiner.social
    shinx.charlgiwnbro.com
    wartortle.satstack.net
)
for host in ${HOSTS[@]}; do
    exec hosts/${hostname}.sh
done

# TODO: also sync to squirtle

du -sh $HOME/archive