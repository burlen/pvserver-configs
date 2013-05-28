#!/bin/bash


echo "staring build on login node .... "

build_dir=$1

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -t edison02 "bash -c \"source /usr/common/graphics/ParaView/dashboards/modules-gnu.sh; cd $build_dir; pwd; nice -n 19 make -j 8\""

echo "finished build on login node"
