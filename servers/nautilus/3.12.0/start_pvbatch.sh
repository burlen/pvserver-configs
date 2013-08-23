#!/bin/bash

if [ $# != 6 ]
then
  echo "Usage: start_pvbatch.sh NCPUS WALLTIME ACCOUNT SCRIPT"
  echo
  echo "  NCPUS     - number of processes in mutiple of 8."
  echo "  MEM       - ram per process. each 8 cpus comes with 32GB ram."
  echo "  WALLTIME  - wall time in HH:MM:SS format."
  echo "  ACCOUNT   - your tg account for billing purposes."
  echo "  QUEUE     - the queue to use."
  echo "  SCRIPT    - path to your python batch script."
  echo
  exit 1
fi

NCPUS=$1
MEM=$2
WALLTIME=$3
ACCOUNT=$4
QUEUE=$5
BATCH_SCRIPT_PATH=$6

MEM=`echo "$NCPUS*$MEM*1000" | bc`
LOGIN_HOST=`/bin/hostname`

export PV_PATH=/sw/analysis/paraview/3.12.0/sles11.1_intel11.1.038

export LD_LIBRARY_PATH=$PV_PATH/lib/paraview-3.12/:/sw/analysis/python/2.7.1/sles11.1_intel11.1/lib:/opt/sgi/mpt/mpt-2.04/lib:/opt/intel/Compiler/11.1/038/lib/intel64:/opt/intel/Compiler/11.1/038/mkl/lib/em64t:/opt/intel/Compiler/11.1/038/ipp/em64t/lib:/opt/intel/Compiler/11.1/038/tbb/em64t/cc4.1.0_libc2.4_kernel2.6.16.21/lib:/opt/torque/3.0.3/lib

export PATH=$PV_PATH/bin:/sw/analysis/python/2.7.1/sles11.1_intel11.1/bin:/opt/sgi/mpt/mpt-2.04/bin:/sw/analysis/git/1.7.6/sles11.1_intel11.1/bin:/nics/e/sw/tools/bin:/usr/local/hsi/bin:/usr/local/gold/bin:/opt/intel/Compiler/11.1/038/bin/intel64:/opt/moab/6.0.4/bin:/opt/torque/3.0.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/lib/mit/bin:/usr/lib/mit/sbin

echo '=========================================================== '
echo '   ___ _   _____       __      __       ____  ______   ___  '
echo '  / _ \ | / / _ )___ _/ /_____/ /  ____|_  / <  /_  | / _ \ '
echo ' / ___/ |/ / _  / _ `/ __/ __/ _ \/___//_ <_ / / __/_/ // / '
echo '/_/   |___/____/\_,_/\__/\__/_//_/   /____(_)_/____(_)___/  '
echo '=========================================================== '
echo
echo "Setting environment..."
#echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
#echo "PATH=$PATH"
echo "ACCOUNT=$ACCOUNT"
echo "NCPUS=$NCPUS"
echo "MEM=$MEM\MB"
echo "WALLTIME=$WALLTIME"
echo "QUEUE=$QUEUE"
echo "LOGIN_HOST=$LOGIN_HOST"
echo "BATCH_SCRIPT_PATH=$BATCH_SCRIPT_PATH"
echo
echo "Starting ParaView in batch mode via qsub..."

# pass these to the script
export MPI_TYPE_MAX=1000000
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
export PV_LOGIN_HOST=$LOGIN_HOST
export PV_BATCH_SCRIPT_PATH=$BATCH_SCRIPT_PATH

JID=`qsub -S /bin/bash -v MPI_TYPE_MAX,PV_PATH,PATH,LD_LIBRARY_PATH,PV_NCPUS,PV_LOGIN_HOST,PV_BATCH_SCRIPT_PATH -N PV-3.12.0-Batch -A $ACCOUNT -q $QUEUE -l ncpus=$NCPUS,mem=$MEM\MB,walltime=$WALLTIME /sw/analysis/paraview/3.12.0/sles11.1_intel11.1.038/start_pvbatch.qsub`
ERRNO=$?
if [ $ERRNO == 0 ] 
then
echo "Job $JID submitted succesfully."
else
echo "ERROR $ERRNO: in job submission."
fi

exit 0
