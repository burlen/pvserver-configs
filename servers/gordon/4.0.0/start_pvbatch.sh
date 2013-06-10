#!/bin/bash

if [ $# != 7 ]
then
  echo "Usage: start_pvbatch.sh NCPUS WALLTIME ACCOUNT QUEUE SCRIPT"
  echo
  echo "  NCPUS     - number of processes in mutiple of 24."
  echo "  NCPUS_PER_NODE - number of processes per socket. 4 sockets per node."
  echo "  RENDER_THREADS - number of threads to use during rendring."
  echo "  WALLTIME  - wall time in HH:MM:SS format."
  echo "  ACCOUNT   - account name to run the job against."
  echo "  QUEUE     - the queue to use."
  echo "  SCRIPT    - full path to the batch script to exec."
  echo
  exit -1
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
SCRIPT=$7

PREFIX=/oasis/projects/nsf/gue998/bloring/installs/

PV_VER_SHORT=4.0
PV_VER_FULL=4.0.0
PV_HOME=$PREFIX/ParaView/$PV_VER_FULL
MESA_HOME=$PREFIX/mesa/9.2.0
LLVM_HOME=$PREFIX/llvm/3.2

LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-$PV_VER_SHORT:$MESA_HOME/lib:/opt/openmpi/gnu/ib/lib:/opt/python/lib:/opt/gnu/libtool/2.4/lib:/opt/gnu/libunistring/0.9.3/lib:/opt/gnu/libffi/3.0.11/lib:/opt/gnu/bdwgc/7.2alpha7/lib:/opt/gnu/guile/2.0.5/lib:/opt/gnu/mpc/0.9/lib:/opt/gnu/mpfr/3.0.1/lib:/opt/gnu/gmp/4.3.2/lib:/opt/gnu/gcc/4.6.1/lib64:/opt/binutils/lib64:/opt/binutils/lib

PATH=$PV_HOME/bin:$NCAT_HOME/bin:$LLVM_HOME/bin:/opt/openmpi/gnu/ib/bin:/opt/python/bin:/opt/autoconf/bin:/opt/gnu/guile/2.0.5/bin:/opt/gnu/libtool/2.4/bin:/opt/gnu/automake/1.11.5/bin:/opt/gnu/autoconf/2.68/bin:/opt/gnu/texinfo/4.13a/bin:/opt/gnu/gdb/7.4/bin:/opt/gnu/gcc/4.6.1/bin:/opt/binutils/bin:/usr/kerberos/bin:/usr/java/latest/bin:/home/servers/gordon/bin:/usr/local/bin:/bin:/usr/bin:/opt/eclipse:/opt/bin:/opt/maui/bin:/opt/torque/bin:/opt/torque/sbin:/opt/torque/bin:/opt/torque/sbin:/state/partition1/catalina/bin:/opt/rocks/bin:/opt/rocks/sbin:/home/bloring/bin

echo '============================================================ '
echo '   ___               _   ___                ____  ___   ___  '
echo '  / _ \___ ________ | | / (_)__ _    ______/ / / / _ \ / _ \ '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___/_  _// // // // / '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/     /_/(_)___(_)___/  '
echo '============================================================ '
echo
echo "Setting environment..."
#echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
#echo "PATH=$PATH"
echo "ACCOUNTS=$ACCOUNTS"
echo "ACCOUNT=$ACCOUNT"
echo "NCPUS=$NCPUS"
echo "NCPUS_PER_NODE=$NCPUS_PER_NODE"
echo "NCPUS_PER_NODE=$NCPUS_PER_NODE"
echo "NNODES=$NNODES"
echo "MEM=$MEM\GB"
echo "RENDER_THREADS=$RENDER_THREADS"
echo "WALLTIME=$WALLTIME"
echo "PORT=$PORT"
echo "ACCOUNT=$ACCOUNT"
echo "QUEUE=$QUEUE"

echo "Starting ParaView via qsub..."

# pass these to the script
export PV_NCPUS=$NCPUS
export PV_NCPUS_PER_NODE=$NCPUS_PER_NODE
export PV_RENDER_THREADS=$RENDER_THREADS
export PV_BATCH_SCRIPT=$SCRIPT
export PV_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export PV_PATH=$PATH
JID=`qsub -V -N PV-3.98.1-batch -A $ACCOUNT -q $QUEUE -l nodes=$NNODES:ppn=$NCPUS_PER_NODE:native,walltime=$WALLTIME $PV_HOME/start_pvbatch.qsub`
ERRNO=$?
if [ $ERRNO == 0 ]
then
echo "Job submitted succesfully."
qstat $JID
else
echo "ERROR $ERRNO: in job submission."
fi
