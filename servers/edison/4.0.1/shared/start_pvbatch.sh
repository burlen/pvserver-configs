#!/bin/bash

if [ $# != 7 ]
then
  echo "Usage: start_pvbatch.sh NCPUS WALLTIME ACCOUNT QUEUE SCRIPT"
  echo
  echo "  NCPUS     - number of processes in mutiple of 24."
  echo "  NCPUS_PER_SOCKET - number of processes per socket. 4 sockets per node."
  echo "  RENDER_THREADS - number of threads to use during rendring."
  echo "  WALLTIME  - wall time in HH:MM:SS format."
  echo "  ACCOUNT   - account name to run the job against."
  echo "  QUEUE     - the queue to use."
  echo "  SCRIPT    - full path to the batch script to exec."
  echo
  exit -1
fi

NCPUS=$1
NCPUS_PER_SOCKET=$2
NCPUS_PER_NODE=`echo 2*$NCPUS_PER_SOCKET | bc`
NNODES=`echo $NCPUS/$NCPUS_PER_NODE | bc`
(( NNODES = NNODES<1 ? 1 : $NNODES ))
MEM=`echo 64*$NNODES | bc`
RENDER_THREADS=$3
(( RENDER_THREADS = RENDER_THREADS<1 ? 1 : $RENDER_THREADS ))
WALLTIME=$4
ACCOUNT=$5
if [[ "$ACCOUNT" == "default" ]]
then
  ACCOUNT=`/usr/common/usg/bin/getnim -U $USER -D | cut -d" " -f1`
fi
ACCOUNTS=`/usr/common/usg/bin/getnim -U $USER | cut -d" " -f1 | tr '\n' ' '`
QUEUE=$6
SCRIPT=$7

PV_VER_SHORT=4.0
PV_VER_FULL=4.0.1
PV_HOME=/usr/common/graphics/ParaView/$PV_VER_FULL
MESA_HOME=/usr/common/graphics/mesa/9.2.0
LLVM_HOME=/usr/common/graphics/llvm/3.2
NCAT_HOME=/usr/common/graphics/ParaView/nmap-6.25

module swap PrgEnv-intel PrgEnv-gnu/5.0.41
module swap gcc gcc/4.8.1
module swap gni-headers gni-headers/3.0-1.0500.7161.11.4.ari
module swap rca rca/1.0.0-2.0500.41336.1.120.ari
module swap dmapp dmapp/6.0.1-1.0500.7263.9.31.ari
module swap pmi pmi/4.0.1-1.0000.9725.84.2.ari
module swap csa csa/3.0.0-1_2.0500.41366.1.129.ari
module swap ugni ugni/5.0-1.0500.0.3.306.ari
module swap udreg udreg/2.3.2-1.0500.6756.2.10.ari
module swap cray-mpich cray-mpich/6.0.2
module swap xpmem xpmem/0.1-2.0500.41356.1.11.ari

LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-$PV_VER_SHORT:$MESA_HOME/lib:/usr/common/usg/python/2.7.3/lib:$LD_LIBRRY_PATH
PATH=$PV_HOME/bin:$NCAT_HOME/bin:$LLVM_HOME/bin:$PATH

echo '=============================================================== '
echo '      ___               _   ___                ____  ___   ___  '
echo '     / _ \___ ________ | | / (_)__ _    ______/ / / / _ \ <  /  '
echo '    / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___/_  _// // / / /   '
echo '   /_/   \_,_/_/  \_,_/|___/_/\__/|__,__/     /_/(_)___(_)_/    '
echo '=============================================================== '
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
echo "MEM=$MEM\GB"
echo "RENDER_THREADS=$RENDER_THREADS"
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
export PV_RENDER_THREADS=$RENDER_THREADS
export PV_BATCH_SCRIPT=$SCRIPT
JID=`qsub -V -N PV-3.98.1-batch -A $ACCOUNT -q $QUEUE -l mppwidth=$NCPUS -l mppnppn=$NCPUS_PER_NODE -l walltime=$WALLTIME $PV_HOME/start_pvbatch.qsub`
ERRNO=$?
if [ $ERRNO == 0 ]
then
echo "Job submitted succesfully."
qstat $JID
else
echo "ERROR $ERRNO: in job submission."
fi
