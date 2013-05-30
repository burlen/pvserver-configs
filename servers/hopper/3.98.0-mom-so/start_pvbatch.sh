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

PV_HOME=/usr/common/graphics/ParaView/3.98.0-mom-so

# modules envirtonment isn't setup when using the ssh command.
LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-3.98:/usr/common/usg/python/2.7.1/lib:/opt/gcc/default/snos/lib64:/opt/gcc/mpc/0.8.1/lib:/opt/gcc/mpfr/2.4.2/lib:/opt/gcc/gmp/4.3.2/lib:/opt/gcc/4.7.1/snos/lib64:/opt/moab/6.1.8/lib

PATH=$PV_HOME/bin:/usr/common/usg/cmake/2.8.9/bin:/usr/common/usg/python/2.7.1/bin:/opt/cray/atp/1.5.0/bin:/opt/cray/xt-asyncpe/5.12/bin:/opt/cray/xpmem/0.1-2.0400.31280.3.1.gem/bin:/opt/cray/dmapp/3.2.1-1.0400.4255.2.159.gem/bin:/opt/cray/pmi/3.0.1-1.0000.9101.2.26.gem/bin:/opt/cray/ugni/2.3-1.0400.4374.4.88.gem/bin:/opt/cray/udreg/2.3.1-1.0400.4264.3.1.gem/bin:/opt/gcc/4.7.1/bin:/usr/common/usg/bin:/usr/common/mss/bin:/usr/common/nsg/bin:/usr/common/usg/darshan/2.2.4-pre3/bin:/usr/common/usg/darshan/2.2.4-pre3/../xt-asyncpe/5.12/bin:/usr/common/usg/altd/1.0/bin:/opt/moab/6.1.8/bin:/opt/torque/2.5.9/sbin:/opt/torque/2.5.9/bin:/opt/cray/eslogin/eswrap/1.0.10/bin:/opt/modules/3.2.6.6/bin:/usr/lpp/mmfs/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:/usr/lib64/jvm/jre/bin:/usr/lib/mit/bin:/usr/lib/mit/sbin:/opt/pathscale/bin:/opt/cray/bin

echo '================================================================= '
echo '   ___               _   ___                ____  ___  ___   ___  '
echo '  / _ \___ ________ | | / (_)__ _    ______|_  / / _ \( _ ) / _ \ '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___//_ <_ \_, / _  |/ // / '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/   /____(_)___/\___(_)___/  '
echo '================================================================= '
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
JID=`qsub -V -N PV-3.98.0-batch -A $ACCOUNT -q $QUEUE -l mppwidth=$NCPUS -l mppnppn=$NCPUS_PER_NODE -l walltime=$WALLTIME $PV_HOME/start_pvbatch.qsub`
ERRNO=$?
if [ $ERRNO == 0 ]
then
echo "Job submitted succesfully."
qstat $JID
else
echo "ERROR $ERRNO: in job submission."
fi
