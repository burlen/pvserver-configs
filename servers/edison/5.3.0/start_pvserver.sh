#!/bin/bash -l

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
MEM=`echo 128*$NNODES | bc`
WALLTIME=$3
ACCOUNT=$4
if [[ "$ACCOUNT" == "default" ]]
then
  ACCOUNT=`/usr/common/software/bin/getnim -U $USER -D | cut -d" " -f1`
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
  ACCOUNTS=`/usr/common/software/bin/getnim -U $USER | cut -d" " -f1 | tr '\n' ' '`
fi
QUEUE=$5
QOS=normal
if [[ "$QUEUE" == "premium" ]]
then
  QUEUE=regular
  QOS=premium
fi
PORT=$6

LOGIN_HOST=$(cat /etc/hosts | grep $(hostname)'[^-]' | tr -s ' ' | cut -d' ' -f1)
let LOGIN_PORT=$PORT+1

# note: mesa  maxes out at 16
# 32 physical cores per socket, 64 with hyperthread
RENDER_THREADS=`echo 32/$NCPUS_PER_SOCKET`
(( RENDER_THREADS = RENDER_THREADS<1 ? 1 : $RENDER_THREADS ))
(( RENDER_THREADS = RENDER_THREADS>16 ? 16 : $RENDER_THREADS ))

PV_VER_SHORT=5.3
PV_VER_FULL=5.3.0
PV_HOME=/usr/common/software/ParaView/$PV_VER_FULL/
NCAT_HOME=/usr/common/software/ParaView/nmap/7.40/

module swap PrgEnv-intel PrgEnv-gnu/5.2.56

PV_LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-$PV_VER_SHORT:$PV_HOME/lib/system-libs:/usr/common/software/ParaView/mesa/17.0.2/lib/:/usr/common/software/ParaView/llvm/4.4.0/lib/:/usr/common/software/ParaView/python/2.7.12/lib
PV_PATH=$PV_HOME/bin

# Python stuff
unset PYTHONSTARTUP
export PYTHONHOME=/usr/common/software/ParaView/python/2.7.12/
export PYTHONPATH=/usr/common/software/ParaView/python/2.7.12/lib:/usr/common/software/ParaView/python/2.7.12/lib/python2.7/site-packages/

echo '=============================================================='
echo '   ___               _   ___                ____   ____  ___  '
echo '  / _ \___ ________ | | / (_)__ _    ______/ __/  |_  / / _ \ '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___/__ \_ _/_ <_/ // / '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/   /____(_)____(_)___/  '
echo '=============================================================='
echo
echo "Please be patient, it may take some time for the job to pass through the queue."
echo "KEEP THIS TERMINAL OPEN WHILE USING PARAVIEW"
echo
echo "Setting environment..."
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
echo "PATH=$PATH"
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
echo "QOS=$QOS"
echo "LOGIN_HOST=${LOGIN_HOST}"
echo "LOGIN_PORT=$LOGIN_PORT"
echo "LINK_TYPE=hybrid"

echo "Forwarding port $LOGIN_PORT to $PORT on ${LOGIN_HOST}..."
$NCAT_HOME/bin/ncat -l ${LOGIN_HOST} $LOGIN_PORT --sh-exec="$NCAT_HOME/bin/ncat localhost $PORT" &

echo "Starting ParaView via qsub..."
# pass these to the script
export PV_HOME
export PV_LD_LIBRARY_PATH
export PV_PATH
export PV_NCAT_PATH=$NCAT_HOME/bin
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
export PV_NCPUS_PER_SOCKET=$NCPUS_PER_SOCKET
export PV_RENDER_THREADS=$RENDER_THREADS
export PV_LOGIN_HOST=${LOGIN_HOST}
export PV_LOGIN_PORT=$LOGIN_PORT
export ATP_ENABLED=1
JID=`sbatch -J ParaView-$PV_VER_FULL -A "$ACCOUNT" -p "$QUEUE" --qos=$QOS --nodes=$NNODES -t $WALLTIME -C haswell $PV_HOME/start_pvserver.qsub`
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
/usr/common/software/ParaView/batchsysmon.sh $JIDNO slurm-${JIDNO}.out
