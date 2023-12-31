#!/bin/bash
set -x
set -e
HOSTS=(
    chespin.satstack.net
    garchomp.bitcoiner.social
    metagross.offchain.pub
    pancham.brenise.com
    sableye.satstack.cloud
    squirtle.satstack.net
    wartortle.satstack.net
)

#source functions.sh
for hostname in ${HOSTS[@]}; do
    echo "Running script for $hostname"
    (exec ./hosts/${hostname}.sh)
    echo "Finished running script for $hostname"
done

du -sh $HOME/archive
