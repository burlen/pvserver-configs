#!/bin/bash

export PV_HOME=/usr/common/graphics/ParaView/builds
source $PV_HOME/modules-gnu.sh

#tmp1="1 `seq 2 2 32`"
#tmp2=($tmp1)
#${tmp2[*]}

for mpinp in `seq 1 16`
do
  for lpnt in `seq 1 16`
  do
    echo "submitting $mpinp $lpnt"
    export lpnt
    export mpinp
    qsub -N llpb-$lpnt-$mpinp -V -q debug -l walltime=00:30:00 -l mppwidth=32 -l mppnppn=32 $PV_HOME/llvmpipe-bench.qsub

    # gordon
    #echo "===================================================================="
    #export LP_NUM_THREADS=$lpnt
    #echo "MPI_RANKS=$mpinp, LP_NUM_THREADS=$LP_NUM_THREADS"
    #bin/pvpython ../asym-2d-lic.py &
    #sleep 10s
    #mpiexec -np $mpinp bin/pvserver --reverse-connection --server-port=33345

    # hopper
    #aprun -n $mpinp -d 24 -cc none bin/pvserver --reverse-connection --server-port=33345 --client-host=$momhost

    # edison
    #aprun -b -n $mpinp -d 1 -j 2 -cc none bin/pvserver --reverse-connection --server-port=33345 --client-host=$momhost

    #ls -lah asym-2d-200.png
    #rm asym-2d-200.png
  done
done
