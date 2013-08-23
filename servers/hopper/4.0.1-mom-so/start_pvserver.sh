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

PV_VER_FULL=4.0.1
PV_VER_SHORT=4.0

PV_HOME=/usr/common/graphics/ParaView/$PV_VER_FULL-mom-so
MESA=/usr/common/graphics/mesa/9.2.0

# modules envirtonment isn't setup when using the ssh command.
LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-$PV_VER_SHORT:$PV_HOME/lib/system-libs/:$MESA/lib:/usr/common/usg/python/2.7.1/lib:/opt/gcc/mpfr/2.4.2/lib:/opt/gcc/gmp/4.3.2/lib:/opt/gcc/4.7.2/snos/lib64:/opt/cray/shared-root/1.0-1.0401.37253.3.50.gem/lib64:/opt/cray/nodehealth/5.0-1.0401.38460.12.18.gem/lib64:/opt/cray/csa/3.0.0-1_2.0401.37452.4.50.gem/lib64:/opt/cray/job/1.5.5-0.1_2.0401.35380.1.10.gem/lib64:/opt/gcc/mpc/0.8.1/lib:/opt/gcc/mpfr/2.4.2/lib

CRAY_LD_LIBRARY_PATH=/opt/cray/mpt/5.6.4/gni/mpich2-gnu/47/lib:/opt/cray/rca/1.0.0-2.0401.38656.2.2.gem/lib64:/opt/cray/xpmem/0.1-2.0401.36790.4.3.gem/lib64:/opt/cray/dmapp/3.2.1-1.0401.5983.4.5.gem/lib64:/opt/cray/pmi/4.0.1-1.0000.9421.73.3.gem/lib64:/opt/cray/ugni/4.0-1.0401.5928.9.5.gem/lib64:/opt/cray/udreg/2.3.2-1.0401.5929.3.3.gem/lib64:/opt/cray/mpt/5.6.4/gni/mpich2-pgi/119/lib:/opt/cray/mpt/5.6.4/gni/sma/lib64:/opt/cray/mpt/5.6.4/gni/sma64/lib64

PATH=$PV_HOME/bin:/usr/common/usg/cmake/2.8.10.1/bin:/usr/common/usg/python/2.7.1/bin:/usr/common/usg/bin:/usr/common/mss/bin:/usr/common/nsg/bin:/usr/common/usg/darshan/2.2.6/bin:/usr/common/usg/altd/1.0/bin:/opt/moab/7.2.3/bin:/opt/moab/7.2.3/sbin:/opt/torque/4.2.3.h5/sbin:/opt/torque/4.2.3.h5/bin:/opt/cray/eslogin/eswrap/1.0.10/bin:/opt/cray/atp/1.6.2/bin:/opt/cray/switch/1.0-1.0401.36779.2.72.gem/bin:/opt/cray/shared-root/1.0-1.0401.37253.3.50.gem/bin:/opt/cray/pdsh/2.26-1.0401.37449.1.1.gem/bin:/opt/cray/nodehealth/5.0-1.0401.38460.12.18.gem/bin:/opt/cray/lbcd/2.1-1.0401.35360.1.2.gem/bin:/opt/cray/hosts/1.0-1.0401.35364.1.115.gem/bin:/opt/cray/configuration/1.0-1.0401.35391.1.2.gem/bin:/opt/cray/ccm/2.2.0-1.0401.37254.2.142/sbin:/opt/cray/ccm/2.2.0-1.0401.37254.2.142/bin:/opt/cray/audit/1.0.0-1.0401.37969.2.32.gem/bin:/opt/cray/rca/1.0.0-2.0401.38656.2.2.gem/bin:/opt/cray/dvs/1.8.6_0.9.0-1.0401.1401.1.120/sbin:/opt/cray/dvs/1.8.6_0.9.0-1.0401.1401.1.120/bin:/opt/cray/csa/3.0.0-1_2.0401.37452.4.50.gem/sbin:/opt/cray/csa/3.0.0-1_2.0401.37452.4.50.gem/bin:/opt/cray/job/1.5.5-0.1_2.0401.35380.1.10.gem/bin:/opt/cray/xpmem/0.1-2.0401.36790.4.3.gem/bin:/opt/cray/dmapp/3.2.1-1.0401.5983.4.5.gem/bin:/opt/cray/pmi/4.0.1-1.0000.9421.73.3.gem/bin:/opt/cray/ugni/4.0-1.0401.5928.9.5.gem/bin:/opt/cray/udreg/2.3.2-1.0401.5929.3.3.gem/bin:/opt/pgi/13.3.0/linux86-64/13.3/bin:/opt/cray/xt-asyncpe/5.19/bin:/usr/syscom/nsg/sbin:/usr/common/nsg/sbin:/usr/common/nsg/bin:/usr/syscom/nsg/bin:/opt/modules/3.2.6.6/bin:/usr/lpp/mmfs/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:/usr/lib64/jvm/jre/bin:/usr/lib/mit/bin:/usr/lib/mit/sbin:/opt/cray/bin


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

echo "Forwarding port $LOGIN_PORT to $PORT on $LOGIN_HOST"
$NCAT_PATH/ncat -l $LOGIN_HOST $LOGIN_PORT --sh-exec="$NCAT_PATH/ncat localhost $PORT" &

echo "Starting ParaView via qsub..."

# pass these to the script
export PV_NCAT_PATH=$NCAT_PATH
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
export PV_NCPUS_PER_SOCKET=$NCPUS_PER_SOCKET
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
