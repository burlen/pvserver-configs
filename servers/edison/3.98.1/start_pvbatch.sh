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

PV_HOME=/usr/common/graphics/ParaView/3.98.1
MESA_HOME=/usr/common/graphics/mesa/9.2.0
LLVM_HOME=/usr/common/graphics/llvm/3.2
NCAT_HOME=/usr/common/graphics/ParaView/nmap-6.25

LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-3.98:$MESA_HOME/lib:/usr/common/usg/boost/1.53/gnu/lib:/opt/gcc/default/snos/lib64:/usr/common/usg/python/2.7.3/lib:/opt/cray/csa/3.0.0-1_2.0500.38439.2.118.ari/lib64:/opt/cray/job/1.5.5-0.1_2.0500.38381.1.103.ari/lib64:/opt/gcc/mpc/0.8.1/lib:/opt/gcc/mpfr/2.4.2/lib:/opt/gcc/gmp/4.3.2/lib:/opt/gcc/4.7.2/snos/lib64:/usr/common/usg/mysql/default/lib/mysql:/usr/syscom/nsg/lib

PATH=$PV_HOME/bin:$NCAT_HOME/bin:$LLVM_HOME/bin:/usr/common/usg/python/ipython/0.13.1/bin:/usr/common/usg/python/matplotlib/1.1.0/bin:/usr/common/usg/python/scipy/0.11.0/bin:/usr/common/usg/python/numpy/1.6.2/bin:/usr/common/usg/python/2.7.3/bin:/usr/common/usg/cmake/2.8.10.2/bin:/opt/cray/atp/1.6.1/bin:/opt/cray/rca/1.0.0-2.0500.39949.5.51.ari/bin:/opt/cray/alps/5.0.2-2.0500.7827.1.1.ari/sbin:/opt/cray/alps/5.0.2-2.0500.7827.1.1.ari/bin:/opt/cray/csa/3.0.0-1_2.0500.38439.2.118.ari/sbin:/opt/cray/csa/3.0.0-1_2.0500.38439.2.118.ari/bin:/opt/cray/job/1.5.5-0.1_2.0500.38381.1.103.ari/bin:/opt/cray/xpmem/0.1-2.0500.39645.2.7.ari/bin:/opt/cray/dmapp/5.0.1-1.0500.6257.4.208.ari/bin:/opt/cray/pmi/4.0.1-1.0000.9421.73.3.ari/bin:/opt/cray/ugni/5.0-1.0500.6415.7.120.ari/bin:/opt/cray/udreg/2.3.2-1.0500.6003.1.18.ari/bin:/opt/gcc/4.7.2/bin:/opt/cray/craype/1.01/bin:/usr/common/usg/bin:/usr/common/mss/bin:/usr/common/nsg/bin:/usr/common/usg/darshan/2.2.5-pre3/bin:/usr/common/usg/darshan/2.2.5-pre3/../craype/1.01/bin:/usr/common/usg/altd/1.0/bin:/usr/common/usg/mysql/default/bin:/opt/moab/7.2.2/bin:/opt/moab/7.2.2/sbin:/opt/torque/4.2.2/sbin:/opt/torque/4.2.2/bin:/opt/cray/switch/1.0-1.0500.38384.1.117.ari/bin:/opt/cray/eslogin/eswrap/1.0.19-1.010001.264.0/bin:/usr/syscom/nsg/sbin:/usr/syscom/nsg/bin:/opt/modules/3.2.6.7/bin:/usr/local/bin:/usr/bin:/bin:/usr/lib/mit/sbin:.:/opt/cray/bin


echo '================================================================ '
echo '   ___               _   ___                ____  ___  ___   ___ '
echo '  / _ \___ ________ | | / (_)__ _    ______|_  / / _ \( _ ) <  / '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___//_ <_ \_, / _  | / /  '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/   /____(_)___/\___(_)_/   '
echo '================================================================ '
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
