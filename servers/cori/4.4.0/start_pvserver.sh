#!/bin/bash

if [ $# != 6 ]
then
  echo "Usage: start_pvserver.sh NCPUS WALLTIME ACCOUNT PORT"
  echo
  echo "  NCPUS     - number of processes in mutiple of 16."
  echo "  NCPUS_PER_SOCKET - number of processes per socket. 2 sockets per node."
  echo "  WALLTIME  - wall time in HH:MM:SS format."
  echo "  ACCOUNT   - account name to run the job against."
  echo "  QUEUE     - the queue to use."
  echo "  PORT      - the port number of the server side tunnel."
  echo
  echo "assumes a reverse tunel is set up on localhost to the remote site."
  echo
  sleep 1d
fi

NCPUS=$1
NCPUS_PER_SOCKET=$2
NCPUS_PER_NODE=`echo 2*$NCPUS_PER_SOCKET | bc`
NNODES=`echo $NCPUS/$NCPUS_PER_NODE | bc`
(( NNODES = NNODES<1 ? 1 : $NNODES ))
CPU_STRIDE=`echo 16/$NCPUS_PER_NODE | bc`
(( CPU_STRIDE = CPU_STRIDE<1 ? 1 : $CPU_STRIDE ))
(( CPU_STRIDE = CPU_STRIDE>16 ? 16 : $CPU_STRIDE ))
MEM=`echo 128*$NNODES | bc`
WALLTIME=$3
ACCOUNT=$4
if [[ "$ACCOUNT" == "default" ]]
then
  ACCOUNT=`/usr/common/usg/bin/getnim -U $USER -D | cut -d" " -f1`
fi
if [[ -z "$ACCOUNT" ]]
then
  echo
  echo "ERROR: NIM Failed to lookup your account. If you know"
  echo "       your accounts please set one manually in the"
  echo "       connection dialog. Your default will be used."
  echo
#  sleep 1d
else
  ACCOUNTS=`/usr/common/usg/bin/getnim -U $USER | cut -d" " -f1 | tr '\n' ' '`
fi
QUEUE=$5
PORT=$6
LOGIN_HOST=$(cat /etc/hosts | grep $(hostname) | tr -s ' ' | cut -d' ' -f1)
let LOGIN_PORT=$PORT+1

# note: mesa  maxes out at 16
# 32 physical cores per socket, 64 with hyperthread
RENDER_THREADS=`echo 32/$NCPUS_PER_SOCKET`
(( RENDER_THREADS = RENDER_THREADS<1 ? 1 : $RENDER_THREADS ))
(( RENDER_THREADS = RENDER_THREADS>16 ? 16 : $RENDER_THREADS ))

PV_VER_SHORT=4.4
PV_VER_FULL=4.4.0
PV_HOME=/usr/common/graphics/ParaView/$PV_VER_FULL/
MESA_HOME=/usr/common/graphics/mesa/11.0.6/
GLU_HOME=/usr/common/graphics/glu/9.0.0
NCAT_HOME=/usr/common/graphics/nmap/7.01

module swap PrgEnv-intel PrgEnv-gnu/5.2.82
module swap PrgEnv-gnu PrgEnv-gnu/5.2.82
module load python/2.7.10

PV_LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-$PV_VER_SHORT:$PV_HOME/lib/system-libs:$MESA_HOME/lib:$GLU_HOME/lib/:/usr/common/software/python/2.7.10/lib
PV_PATH=$PV_HOME/bin

echo '=============================================================='
echo '   ___               _   ___                ____ ____  ___  '
echo '  / _ \___ ________ | | / (_)__ _    ______/ / // / / / _ \ '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___/_  _/_  _// // / '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/     /_/(_)_/(_)___/  '
echo '=============================================================='
echo
echo "Please be patient, it may take some time for the job to pass through the queue."
echo "KEEP THIS TERMINAL OPEN WHILE USING PARAVIEW"
echo
echo "Setting environment..."
#echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
#echo "PATH=$PATH"
echo "ACCOUNTS=$ACCOUNTS"
echo "ACCOUNT=$ACCOUNT"
echo "NCPUS=$NCPUS"
echo "NCPUS_PER_SOCKET=$NCPUS_PER_SOCKET"
echo "NCPUS_PER_NODE=$NCPUS_PER_NODE"
echo "CPU_STRIDE=$CPU_STRIDE"
echo "NNODES=$NNODES"
echo "MEM=$MEM\GB"
echo "RENDER_THREADS=$RENDER_THREADS"
echo "WALLTIME=$WALLTIME"
echo "PORT=$PORT"
echo "ACCOUNT=$ACCOUNT"
echo "QUEUE=$QUEUE"
echo "LOGIN_HOST=$LOGIN_HOST"
echo "LOGIN_PORT=$LOGIN_PORT"
echo "LINK_TYPE=hybrid"

echo "Forwarding port $LOGIN_PORT to $PORT on $LOGIN_HOST..."
$NCAT_HOME/bin/ncat -l $LOGIN_HOST $LOGIN_PORT --sh-exec="$NCAT_HOME/bin/ncat localhost $PORT" &

echo "Starting ParaView via qsub..."
# pass these to the script
export PV_HOME
export PV_LD_LIBRARY_PATH
export PV_PATH
export PV_NCAT_PATH=$NCAT_HOME/bin
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
export PV_NCPUS_PER_SOCKET=$NCPUS_PER_SOCKET
export PV_CPU_STRIDE=$CPU_STRIDE
export PV_RENDER_THREADS=$RENDER_THREADS
export PV_LOGIN_HOST=$LOGIN_HOST
export PV_LOGIN_PORT=$LOGIN_PORT
export ATP_ENABLED=1
JID=`sbatch -J ParaView-$PV_VER_FULL -A "$ACCOUNT" -p "$QUEUE" --nodes=$NNODES -t $WALLTIME $PV_HOME/start_pvserver.qsub`
ERRNO=$?
if [ $ERRNO == 0 ]
then
echo "Job submitted succesfully."
else
echo "ERROR $ERRNO: in job submission."
fi

# monitor the batch system and provide
# a simple UI for probing job status
JIDNO="${JID//[!0-9]/}"
/usr/common/graphics/ParaView/batchsysmon.sh $JIDNO slurm-${JIDNO}.out
