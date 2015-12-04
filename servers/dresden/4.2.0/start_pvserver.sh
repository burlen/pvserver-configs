#!/bin/bash

if [ $# != 2 ]
then
  echo "ERROR: incorrect number of arguments, $#."
  echo
  echo "Usage: start_pvserver np XXXXX"
  echo "  np     - number of processes."
  echo "  XXXXX  - port number."
  echo
  echo "assumes a reverse tunel is set up on localhost to the remote site."
  echo
  sleep 1d
fi

NCPUS=$1
PORT=$2

# note: mesa  maxes out at 16
# 12 physical cores per socket, 24 with hyperthread
RENDER_THREADS=`echo 48/$NCPUS`
(( RENDER_THREADS = RENDER_THREADS<1 ? 1 : $RENDER_THREADS ))
(( RENDER_THREADS = RENDER_THREADS>16 ? 16 : $RENDER_THREADS ))

PV_VER_SHORT=4.2
PV_VER_FULL=4.2.0
PV_HOME=/usr/common/graphics/xeon/ParaView/$PV_VER_FULL/

PV_LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-$PV_VER_SHORT
PV_PATH=$PV_HOME/bin

echo '=============================================================='
echo '   ___               _   ___                ____   ___   ___  '
echo '  / _ \___ ________ | | / (_)__ _    ______/ / /  |_  | / _ \ '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___/_  _/ / __/_/ // / '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/     /_/(_)____(_)___/  '
echo '=============================================================='
echo
echo "Please be patient, it may take some time for the job to pass through the queue."
echo "KEEP THIS TERMINAL OPEN WHILE USING PARAVIEW"
echo
echo "Setting environment..."
#echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
#echo "PATH=$PATH"
echo "NCPUS=$NCPUS"
#echo "RENDER_THREADS=$RENDER_THREADS"
echo "WALLTIME=$WALLTIME"
echo "PORT=$PORT"

module load openmpi/1.8.2

echo "Starting ParaView..."

export PV_HOME
export LD_LIBRARY_PATH=$PV_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
export PATH=$PV_PATH:$PATH
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
#export LP_NUM_THREADS=$PV_RENDER_THREADS

mpiexec -np $PV_NCPUS pvserver --reverse-connection --use-offscreen-rendering --server-port=$PV_PORT --client-host=localhost
