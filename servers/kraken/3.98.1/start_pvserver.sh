#!/bin/bash

if [ $# != 7 ]
then
  echo "Usage: start_pvserver.sh NCPUS WALLTIME ACCOUNT PORT"
  echo
  echo "  NCPUS     - number of processes in mutiple of 24."
  echo "  NCPUS_PER_SOCKET - number of processes per socket. 4 sockets per node."
  echo "  RENDER_THREADS - number of threads to use during rendring."
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
SIZE=`echo 12*$NNODES | bc`
MEM=`echo 16*$NNODES | bc`
RENDER_THREADS=$3
(( RENDER_THREADS = RENDER_THREADS<1 ? 1 : $RENDER_THREADS ))
WALLTIME=$4
ACCOUNT=$5
if [[ "$ACCOUNT" == "default" ]]
then
  ACCOUNT=`qsub -A invalid -I 2>&1 | grep '[A-Z][A-Z]-' | line`
fi
ACCOUNTS=`qsub -A invalid -I 2>&1 | grep '[A-Z][A-Z]-' | cut -d' ' -f4`
QUEUE=$6
PORT=$7
LOGIN_HOST=`/bin/hostname`
let LOGIN_PORT=$PORT+1

PV_PREFIX=/lustre/scratch/proj/sw/paraview/
PV_VER_SHORT=3.98
PV_VER_FULL=3.98.1
PV_HOME=$PV_PREFIX/$PV_VER_FULL
MESA_HOME=/usr/common/graphics/mesa/9.1.3
LLVM_HOME=/usr/common/graphics/llvm/3.2
NCAT_HOME=$PV_PREFIX/shared-dependencies/

LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-$PV_VER_SHORT:/lustre/scratch/proj/sw/python-cnl/2.7.1/cnl3.1_gnu4.6.2/lib:/lustre/scratch/proj/sw/python-cnl/2.7.1/cnl3.1_gnu4.6.2/lib/system-dynlib:/opt/gcc/mpc/0.8.1/lib:/opt/gcc/mpfr/2.4.2/lib:/opt/gcc/gmp/4.3.2/lib:/opt/gcc/4.6.2/snos/lib64:/sw/xt/globus/5.0.4/binary/lib:/opt/torque/2.5.11/lib:/opt/cray/MySQL/5.0.64-1.0301.2899.20.1.ss/lib64/mysql:/opt/cray/MySQL/5.0.64-1.0301.2899.20.1.ss/lib64:/opt/cray/portals/2.2.0-1.0301.26633.6.9.ss/lib64:/opt/cray/atp/1.4.1/lib

PATH=$PV_HOME/lib/paraview-$PV_VER_SHORT:$NCAT_HOME/bin:/lustre/scratch/proj/sw/python-cnl/2.7.1/cnl3.1_gnu4.6.2/bin:/sw/xt-cle3.1/git/1.7.4.2/sles11.1_gnu4.6.1/bin:/sw/xt-cle3.1/cmake/2.8.10.2/sles11.1_gnu4.3.2/bin:/opt/cray/atp/1.4.1/bin:/opt/cray/xt-asyncpe/5.11/bin:/opt/cray/pmi/2.1.4-1.0000.8596.15.1.ss/bin:/opt/gcc/4.6.2/bin:/sw/xt/globus/5.0.4/binary/bin:/sw/xt/globus/5.0.4/binary/sbin:/sw/altd/bin:/sw/xt/tgusage/3.0-r3/binary/bin:/usr/local/hsi/bin:/usr/local/gold/bin:/sw/xt/bin:/opt/moab/6.1.6/bin:/opt/torque/2.5.11/bin:/opt/cray/lustre-cray_ss_s/1.8.4_2.6.27.48_0.12.1_1.0301.5943.18.1-1.0301.27524.1.24/sbin:/opt/cray/lustre-cray_ss_s/1.8.4_2.6.27.48_0.12.1_1.0301.5943.18.1-1.0301.27524.1.24/bin:/opt/cray/MySQL/5.0.64-1.0301.2899.20.1.ss/sbin:/opt/cray/MySQL/5.0.64-1.0301.2899.20.1.ss/bin:/opt/cray/sdb/1.0-1.0301.25929.4.88.ss/bin:/opt/cray/nodestat/2.2-1.0301.25918.4.1.ss/bin:/opt/modules/3.2.6.6/bin:/usr/local/bin:/usr/bin:/bin


echo '================================================================ '
echo '   ___               _   ___                ____  ___  ___   ___ '
echo '  / _ \___ ________ | | / (_)__ _    ______|_  / / _ \( _ ) <  / '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___//_ <_ \_, / _  | / /  '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/   /____(_)___/\___(_)_/   '
echo '================================================================ '
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
echo "RENDER_THREADS=$RENDER_THREADS"
echo "WALLTIME=$WALLTIME"
echo "PORT=$PORT"
echo "ACCOUNT=$ACCOUNT"
echo "QUEUE=$QUEUE"
echo "LOGIN_HOST=$LOGIN_HOST"
echo "LOGIN_PORT=$LOGIN_PORT"

echo "Forwarding port $LOGIN_PORT to $PORT on $LOGIN_HOST"
$NCAT_HOME/bin/ncat -l $LOGIIN_HOST $LOGIN_PORT --sh-exec="$NCAT_HOME/bin/ncat localhost $PORT" &

echo "Starting ParaView via qsub..."

# pass these to the script
export PV_NCAT_PATH=$NCAT_HOME/bin
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
export PV_NCPUS_PER_SOCKET=$NCPUS_PER_SOCKET
export PV_RENDER_THREADS=$RENDER_THREADS
export PV_LOGIN_HOST=$LOGIN_HOST
#export PV_LOGIN_PORT=$LOGIN_PORT
JID=`qsub -V -N PV-$PV_VER_FULL-$PORT -A $ACCOUNT -q $QUEUE -l size=$SIZE,walltime=$WALLTIME $PV_HOME/start_pvserver.qsub`
ERRNO=$?
if [ $ERRNO == 0 ]
then
echo "Job submitted succesfully."
else
echo "ERROR $ERRNO: in job submission."
fi


JIDNO=`echo $JID | cut -d. -f1`
JERRF=PV-$PV_VER_FULL-$PORT.e$JIDNO

$PV_PREFIX/batchsys_mon.sh $JID $JERRF

