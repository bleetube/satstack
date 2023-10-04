#!/bin/bash
set -x
HOSTS=(
    chespin.satstack.net
    garchomp.bitcoiner.social
    metagross.bitcoiner.social
    rhyperior.bitcoiner.social
    pancham.brenise.com
    sableye.satstack.cloud
    shinx.charlgiwnbro.com
    squirtle.satstack.net
    wartortle.satstack.net
)

#source functions.sh
for hostname in ${HOSTS[@]}; do
    echo "Running script for $hostname"
    (exec ./hosts/${hostname}.sh)
    echo "Finished running script for $hostname"
done

rsync -taP $HOME/archive blee@squirtle.satstack.net:
du -sh $HOME/archive
