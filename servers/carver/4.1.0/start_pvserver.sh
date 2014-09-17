#/bin/bash -l

if [ $# != 7 ]
then
  echo "Usage: start_pvserver.sh NCPUS WALLTIME ACCOUNT PORT"
  echo
  echo "  NNODES        - number of compute nodes each with 8 cores."
  echo "  NCPU_PER_NODE - number of processes per node (1-8)."
  echo "  NODE_TYPE     - type of node, small, big, xl"
  echo "  WALLTIME      - wall time in HH:MM:SS format."
  echo "  ACCOUNT       - account name to run the job against."
  echo "  QUEUE         - the queue to use."
  echo "  PORT          - the port number of the server side tunnel."
  echo
  echo "assumes a reverse tunel is set up on localhost to the remote site."
  echo
  sleep 1d
fi


NNODES=$1
NCPU_PER_NODE=$2
NODE_TYPE=$3
NCPUS=`echo $NNODES*$NCPU_PER_NODE | bc`
#MAX_CPUS=512
#((NCPUS = NCPUS > MAX_CPUS ? MAX_CPUS : NCPUS))
WALLTIME=$4
ACCOUNT=$5
QUEUE=$6
PORT=$7
LOGIN_HOST=`/bin/hostname`
let LOGIN_PORT=$PORT+1

PV_VER_SHORT=4.1
PV_VER_LONG=4.1.0

export PV_PATH=/usr/common/graphics/ParaView/$PV_VER_LONG

LD_LIBRARY_PATH=$PV_PATH/lib/paraview-$PV_VER_SHORT:/usr/common/graphics/MesaGLU/9.0.0/lib:/usr/common/graphics/Mesa3D/10.2.6/lib:/usr/common/graphics/llvm/3.4.2/lib:/usr/common/usg/atlas/3.10.2/gnu-nothread/lib:/usr/common/usg/gcc/default/lib64:/usr/common/usg/python/2.7.8/lib:/usr/common/usg/openmpi/1.8.1/gcc/lib:/usr/common/usg/mpc/default/lib:/usr/common/usg/gmp/default/lib:/usr/common/usg/mpfr/default/lib:/usr/common/usg/gcc/4.8.3/lib64:/usr/common/usg/gcc/4.8.3/lib:/usr/common/usg/OFED/gcc4.8.3/2.0-3.0.0-Mellanox/lib:/usr/syscom/opt/torque/4.2.7.h1/lib:/usr/syscom/nsg/lib

PATH=$PV_PATH/bin:/usr/common/graphics/llvm/3.4.2/bin:/usr/common/usg/python/ipython/2.2.0/bin:/usr/common/usg/python/matplotlib/1.3.1/bin:/usr/common/usg/python/scipy/0.14.0/bin:/usr/common/usg/python/numpy/1.8.2/bin:/usr/common/usg/python/2.7.8/bin:/usr/common/usg/openmpi/1.8.1/gcc/bin:/usr/common/usg/gcc/4.8.3/bin:/usr/common/usg/OFED/gcc4.8.3/2.0-3.0.0-Mellanox/bin:/usr/common/usg/bin:/usr/common/mss/bin:/usr/common/nsg/bin:/usr/lib64/qt-3.3/bin:/usr/syscom/opt/torque/4.2.7.h1/bin:/usr/syscom/opt/moab/7.2.7-e7c070d1-b4/bin:/usr/syscom/nsg/sbin:/usr/syscom/nsg/bin:/usr/share/Modules/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin

export _LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export _PATH=$PATH

echo '==========================================================='
echo '   ___               _   ___                ____  ___ ___  '
echo '  / _ \___ ________ | | / (_)__ _    ______/ / / <  // _ \ '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___/_  _/ / // // / '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/     /_/(_)_(_)___/  '
echo '==========================================================='
echo
echo "Please be patient, it may take some time for the job to pass through the queue."
echo "KEEP THIS TERMINAL OPEN WHILE USING PARAVIEW"
echo
echo "Setting environment..."
#echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
#echo "PATH=$PATH"
echo "ACCOUNT=$ACCOUNT"
echo "NNODES=$NNODES"
echo "NCPU_PER_NODE=$NCPU_PER_NODE"
echo "NCPUS=$NCPUS"
echo "MEM_PER_CPU=$MEM_PER_CPU"
echo "WALLTIME=$WALLTIME"
echo "PORT=$PORT"
echo "ACCOUNT=$ACCOUNT"
echo "QUEUE=$QUEUE"
echo "LOGIN_HOST=$LOGIN_HOST"
echo "LOGIN_PORT=$LOGIN_PORT"

echo "Forwarding port $LOGIN_PORT to $PORT on $LOGIN_HOST"
export NCAT_PATH=/usr/common/graphics/nmap/6.47/
$NCAT_PATH/bin/ncat -l $LOGIN_HOST $LOGIN_PORT --sh-exec="$NCAT_PATH/bin/ncat localhost $PORT" &

echo "Starting ParaView via qsub..."

# pass these to the script
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
export PV_LOGIN_HOST=$LOGIN_HOST
export PV_LOGIN_PORT=$LOGIN_PORT

case $NODE_TYPE in
  regular)
    MEM_PER_CPU=`echo "20480/$NCPU_PER_NODE" | bc`MB
    MODIFIER=
    ;;
  bigmem)
    MEM_PER_CPU=`echo "45056/$NCPU_PER_NODE" | bc`MB
    MODIFIER=:bigmem
    ;;
esac

JID=`qsub -S /bin/bash -v PV_PATH,_PATH,_LD_LIBRARY_PATH,PV_NCPUS,PV_PORT,PV_LOGIN_HOST,PV_LOGIN_PORT,CHOS -N PV-$PV_VER_LONG-$PORT -A $ACCOUNT -q $QUEUE -l nodes=$NNODES:ppn=${NCPU_PER_NODE}${MODIFIER},pvmem=$MEM_PER_CPU,walltime=$WALLTIME $PV_PATH/start_pvserver.qsub`
ERRNO=$?
if [ $ERRNO == 0 ]
then
  echo "Job $JID submitted succesfully."
else
  echo "ERROR $ERRNO: in job submission."
fi

# monitor the batch system and provide
# a simple UI for probing job status
JERRF=~/$JID.ER
/usr/common/graphics/ParaView/batchsysmon.sh $JID $JERRF
