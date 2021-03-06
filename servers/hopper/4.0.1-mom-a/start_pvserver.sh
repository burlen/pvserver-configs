#!/bin/bash

if [ $# != 6 ]
then
  echo "Usage: start_pvserver.sh NCPUS WALLTIME ACCOUNT PORT"
  echo
  echo "  NCPUS     - number of processes in mutiple of 24."
  echo "  NCPUS_PER_SOCKET - number of processes per socket. 4 sockets per node."
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
LP_NUM_THREADS=`echo 6/$NCPUS_PER_SOCKET`
(( LP_NUM_THREADS = LP_NUM_THREADS<1 ? 1 : $LP_NUM_THREADS ))
NCPUS_PER_NODE=`echo 4*$NCPUS_PER_SOCKET | bc`
NNODES=`echo $NCPUS/$NCPUS_PER_NODE | bc`
(( NNODES = NNODES<1 ? 1 : $NNODES ))
MEM=`echo 32*$NNODES | bc`
WALLTIME=$3
ACCOUNT=$4
if [[ "$ACCOUNT" == "default" ]]
then
  ACCOUNT=`/usr/common/usg/bin/getnim -U $USER -D | cut -d" " -f1`
fi
ACCOUNTS=`/usr/common/usg/bin/getnim -U $USER | cut -d" " -f1 | tr '\n' ' '`
QUEUE=$5
PORT=$6
LOGIN_HOST=`/bin/hostname`
let LOGIN_PORT=$PORT+1

module swap PrgEnv-pgi PrgEnv-gnu/4.1.40
module swap xt-asyncpe xt-asyncpe/5.19
module swap udreg udreg/2.3.2-1.0401.5929.3.3.gem
module swap csa csa/3.0.0-1_2.0401.37452.4.50.gem
module swap gcc gcc/4.7.2
module swap cray-mpich2 cray-mpich2/5.6.4
module swap xpmem xpmem/0.1-2.0401.36790.4.3.gem
module swap xt-asyncpe xt-asyncpe/5.19
module swap gni-headers gni-headers/2.1-1.0401.5675.4.4.gem
module swap dmapp dmapp/3.2.1-1.0401.5983.4.5.gem
module swap pmi pmi/4.0.1-1.0000.9421.73.3.gem
module swap cray-shmem cray-shmem/5.6.4
module swap rca rca/1.0.0-2.0401.38656.2.2.gem
module swap ugni ugni/4.0-1.0401.5928.9.5.gem

PV_VER_FULL=4.0.1
PV_VER_SHORT=4.0

PV_HOME=/usr/common/graphics/ParaView/$PV_VER_FULL-mom-a

MESA=/usr/common/graphics/mesa/9.2.0
LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-$PV_VER_SHORT:$PV_HOME/lib/system-libs/:$MESA/lib:$LD_LIBRARY_PATH

PATH=$PV_HOME/bin:$PATH

NCAT_PATH=/usr/common/graphics/ParaView/nmap-5.51/bin

echo '============================================================'
echo '   ___               _   ___                ____  ___   ___ '
echo '  / _ \___ ________ | | / (_)__ _    ______/ / / / _ \ <  / '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___/_  _// // / / /  '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/     /_/(_)___(_)_/   '
echo '============================================================'
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
echo "NNODES=$NNODES"
echo "MEM=$MEM\GB"
echo "LP_NUM_THREADS=$LP_NUM_THREADS"
echo "WALLTIME=$WALLTIME"
echo "PORT=$PORT"
echo "ACCOUNT=$ACCOUNT"
echo "QUEUE=$QUEUE"
echo "LOGIN_HOST=$LOGIN_HOST"
echo "LOGIN_PORT=$LOGIN_PORT"
echo "DSL=0"

echo "Forwarding port $LOGIN_PORT to $PORT on $LOGIN_HOST"
$NCAT_PATH/ncat -l $LOGIN_HOST $LOGIN_PORT --sh-exec="$NCAT_PATH/ncat localhost $PORT" &

echo "Starting ParaView via qsub..."

# pass these to the script
export PV_HOME
export PV_NCAT_PATH=$NCAT_PATH
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
export PV_NCPUS_PER_SOCKET=$NCPUS_PER_SOCKET
export PV_NNODES=$NNODES
export PV_LOGIN_HOST=$LOGIN_HOST
export PV_LOGIN_PORT=$LOGIN_PORT
export LP_NUM_THREADS
JID=`qsub -V -N PV-$PV_VER_FULL-$PORT -A $ACCOUNT -q $QUEUE -l mppwidth=$NCPUS -l mppnppn=$NCPUS_PER_NODE -l walltime=$WALLTIME $PV_HOME/start_pvserver.qsub`
ERRNO=$?
if [ $ERRNO == 0 ]
then
echo "Job submitted succesfully."
else
echo "ERROR $ERRNO: in job submission."
fi

# monitor the batch system and provide
# a simple UI for probing job status
JIDNO=`echo $JID | cut -d. -f1`
JERRF=~/PV-$PV_VER_FULL-$PORT.e$JIDNO
/usr/common/graphics/ParaView/batchsysmon.sh $JID $JERRF
