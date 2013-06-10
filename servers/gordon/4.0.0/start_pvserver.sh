#!/bin/bash

if [ $# != 7 ]
then
  echo "Usage: start_pvserver.sh NCPUS WALLTIME ACCOUNT PORT"
  echo
  echo "  NCPUS     - number of processes in mutiple of 16."
  echo "  NCPUS_PER_NODE - number of processes per socket. 2 sockets per node."
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
NCPUS_PER_NODE=$2
NNODES=`echo $NCPUS/$NCPUS_PER_NODE | bc`
(( NNODES = NNODES<1 ? 1 : $NNODES ))
MEM=`echo 64*$NNODES | bc`
RENDER_THREADS=$3
(( RENDER_THREADS = RENDER_THREADS<1 ? 1 : $RENDER_THREADS ))
WALLTIME=$4
ACCOUNT=$5
ACCOUNTS=`/home/servers/gordon/bin/show_accounts | grep $USER | tr -s ' ' | cut -d' ' -f2 | tr '\n' ' '`
if [[ "$ACCOUNT" == "default" ]]
then
  ACCOUNT=`echo $ACCOUNTS | cut -d' ' -f1`
fi
QUEUE=$6
PORT=$7
LOGIN_HOST=`/bin/hostname`
let LOGIN_PORT=$PORT+1

PREFIX=/oasis/projects/nsf/gue998/bloring/installs/

PV_VER_SHORT=4.0
PV_VER_FULL=4.0.0
PV_HOME=$PREFIX/ParaView/$PV_VER_FULL
MESA_HOME=$PREFIX/mesa/9.2.0
LLVM_HOME=$PREFIX/llvm/3.2
NCAT_HOME=$PREFIX/nmap/5.00

LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-$PV_VER_SHORT:$MESA_HOME/lib:/opt/openmpi/gnu/ib/lib:/opt/python/lib:/opt/gnu/libtool/2.4/lib:/opt/gnu/libunistring/0.9.3/lib:/opt/gnu/libffi/3.0.11/lib:/opt/gnu/bdwgc/7.2alpha7/lib:/opt/gnu/guile/2.0.5/lib:/opt/gnu/mpc/0.9/lib:/opt/gnu/mpfr/3.0.1/lib:/opt/gnu/gmp/4.3.2/lib:/opt/gnu/gcc/4.6.1/lib64:/opt/binutils/lib64:/opt/binutils/lib

PATH=$PV_HOME/bin:$NCAT_HOME/bin:$LLVM_HOME/bin:/opt/openmpi/gnu/ib/bin:/opt/python/bin:/opt/autoconf/bin:/opt/gnu/guile/2.0.5/bin:/opt/gnu/libtool/2.4/bin:/opt/gnu/automake/1.11.5/bin:/opt/gnu/autoconf/2.68/bin:/opt/gnu/texinfo/4.13a/bin:/opt/gnu/gdb/7.4/bin:/opt/gnu/gcc/4.6.1/bin:/opt/binutils/bin:/usr/kerberos/bin:/usr/java/latest/bin:/home/servers/gordon/bin:/usr/local/bin:/bin:/usr/bin:/opt/eclipse:/opt/bin:/opt/maui/bin:/opt/torque/bin:/opt/torque/sbin:/opt/torque/bin:/opt/torque/sbin:/state/partition1/catalina/bin:/opt/rocks/bin:/opt/rocks/sbin:/home/bloring/bin

echo '============================================================ '
echo '   ___               _   ___                ____  ___   ___  '
echo '  / _ \___ ________ | | / (_)__ _    ______/ / / / _ \ / _ \ '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___/_  _// // // // / '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/     /_/(_)___(_)___/  '
echo '============================================================ '
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

# don't seem to need this when joining two ssh tunnels
echo "Forwarding port $LOGIN_PORT to $PORT on $LOGIN_HOST"
$NCAT_HOME/bin/ncat -l $LOGIIN_HOST $LOGIN_PORT --sh-exec="$NCAT_HOME/bin/ncat localhost $PORT" &

echo "Starting ParaView via qsub..."

# pass these to the script
export PV_NCAT_PATH=$NCAT_HOME/bin
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
export PV_NCPUS_PER_NODE=$NCPUS_PER_NODE
export PV_RENDER_THREADS=$RENDER_THREADS
export PV_LOGIN_HOST=$LOGIN_HOST
export PV_LOGIN_PORT=$LOGIN_PORT
export PV_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export PV_PATH=$PATH
JID=`qsub -V -N PV-$PV_VER_FULL-$PORT -A $ACCOUNT -q $QUEUE -l nodes=$NNODES:ppn=$NCPUS_PER_NODE:native,walltime=$WALLTIME $PV_HOME/start_pvserver.qsub`
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
$PREFIX/ParaView/batchsysmon.sh $JID $JERRF
