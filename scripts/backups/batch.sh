#!/bin/bash
HOSTS=(
    garchomp.bitcoiner.social
    metagross.bitcoiner.social
    rhyperior.bitcoiner.social
    shinx.charlgiwnbro.com
    wartortle.satstack.net
)

source functions.sh
for hostname in ${HOSTS[@]}; do
    echo "Running script for $hostname"
    (exec ./hosts/${hostname}.sh)
    echo "Finished running script for $hostname"
done

du -sh $HOME/archive
rsync -ta $HOME/archive blee@squirtle.satstack.net:
