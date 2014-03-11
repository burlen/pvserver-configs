#!/bin/bash

if [ $# != 6 ]
then
  echo "Usage: start_pvbatch.sh NCPUS WALLTIME ACCOUNT QUEUE SCRIPT"
  echo
  echo "  NCPUS     - number of processes in mutiple of 24."
  echo "  NCPUS_PER_SOCKET - number of processes per socket. 4 sockets per node."
  echo "  WALLTIME  - wall time in HH:MM:SS format."
  echo "  ACCOUNT   - account name to run the job against."
  echo "  QUEUE     - the queue to use."
  echo "  SCRIPT    - full path to the batch script to exec."
  echo
  exit -1
fi

NCPUS=$1
NCPUS_PER_SOCKET=$2
NCPUS_PER_NODE=`echo 4*$NCPUS_PER_SOCKET | bc`
NNODES=`echo $NCPUS/$NCPUS_PER_NODE | bc`
(( NNODES = NNODES<1 ? 1 : $NNODES ))
LP_NUM_THREADS=`echo 6/$NCPUS_PER_SOCKET`
(( LP_NUM_THREADS = LP_NUM_THREADS<1 ? 1 : $LP_NUM_THREADS ))
MEM=`echo 32*$NNODES | bc`
WALLTIME=$3
ACCOUNT=$4
if [[ "$ACCOUNT" == "default" ]]
then
  ACCOUNT=`/usr/common/usg/bin/getnim -U $USER -D | cut -d" " -f1`
fi
ACCOUNTS=`/usr/common/usg/bin/getnim -U $USER | cut -d" " -f1 | tr '\n' ' '`
QUEUE=$5
SCRIPT=$6

module swap PrgEnv-pgi PrgEnv-gnu/4.2.34
module load python/2.7.5
module load mesa/9.2.2-llvmpipe-dso

PV_VER_FULL=4.1.0
PV_VER_SHORT=4.1

PV_HOME=/usr/common/graphics/ParaView/$PV_VER_FULL-mom-so

LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-$PV_VER_SHORT:$PV_HOME/lib/system-libs/:$LD_LIBRARY_PATH
PATH=$PV_HOME/bin:$PATH

NCAT_PATH=/usr/common/graphics/ParaView/nmap-5.51/bin

echo '======================================================='
echo '   ___ _   ____        __      __       ____  ___ ___  '
echo '  / _ \ | / / /  ___ _/ /_____/ /  ____/ / / <  // _ \ '
echo ' / ___/ |/ / _ \/ _ `/ __/ __/ _ \/___/_  _/ / // // / '
echo '/_/   |___/_.__/\_,_/\__/\__/_//_/     /_/(_)_(_)___/  '
echo '======================================================='
echo
echo "Setting environment..."
#echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
#echo "PATH=$PATH"
echo "ACCOUNTS=$ACCOUNTS"
echo "ACCOUNT=$ACCOUNT"
echo "NCPUS=$NCPUS"
echo "NCPUS_PER_SOCKET=$NCPUS_PER_SOCKET"
echo "NCPUS_PER_NODE=$NCPUS_PER_NODE"
echo "NNODES=$NNODES"
echo "LP_NUM_THREADS=$LP_NUM_THREADS"
echo "MEM=$MEM\GB"
echo "WALLTIME=$WALLTIME"
echo "PORT=$PORT"
echo "ACCOUNT=$ACCOUNT"
echo "QUEUE=$QUEUE"
echo "LOGIN_HOST=$LOGIN_HOST"
echo "LOGIN_PORT=$LOGIN_PORT"

echo "Starting ParaView via qsub..."

# pass these to the script
export PV_NCPUS=$NCPUS
export PV_NCPUS_PER_SOCKET=$NCPUS_PER_SOCKET
export PV_BATCH_SCRIPT=$SCRIPT
JID=`qsub -V -N PV-$PV_VER_FULL-batch -A $ACCOUNT -q $QUEUE -l mppwidth=$NCPUS -l mppnppn=$NCPUS_PER_NODE -l walltime=$WALLTIME $PV_HOME/start_pvbatch.qsub`
ERRNO=$?
if [ $ERRNO == 0 ]
then
echo "Job submitted succesfully."
qstat $JID
else
echo "ERROR $ERRNO: in job submission."
fi
