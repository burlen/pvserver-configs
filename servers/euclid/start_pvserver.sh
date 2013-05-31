#!/bin/bash

if [ $# != 3 ]
then
  echo "ERROR: incorrect number of arguments, $#."
  echo
  echo "Usage: start_pvserver np XXXXX"
  echo "  np     - number of processes."
  echo "  XXXXX  - port number."
  echo "  ver    - version number of installed PV."
  echo 
  echo "assumes a reverse tunel is set up on localhost to the remote site."
  echo
  sleep 1d
fi

PV_VER=$1
MPI_NP=$2
PORT=$3

# modules envirtonment isn't setup when using the ssh command.

case $PV_VER in
  3.8.1)
    echo '==============================================================='
    echo '   ___               _   ___                    ____  ___   ___'
    echo '  / _ \___ ________ | | / (_)__ _    __  ____  |_  / ( _ ) <  /'
    echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ / /___/ _/_ <_/ _  | / / '
    echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/       /____(_)___(_)_/  '
    echo '==============================================================='
    echo
    echo "Please be patient, it may take some time for the job to pass through the queue."
    echo "KEEP THIS TERMINAL OPEN WHILE USING PARAVIEW"
    echo
    echo "Setting environment..." 
    export LD_LIBRARY_PATH=/usr/common/graphics/ParaView/$PV_VER/lib:/usr/common/usg/openmpi/1.4.1/gnu/lib:$LD_LIBRARY_PATH
    export PATH=/usr/common/graphics/ParaView/$PV_VER/bin:/usr/common/usg/openmpi/1.4.1/gnu/bin:$PATH
    ;;

  3.10.0)
    echo '================================================================'
    echo '   ___               _   ___                ____  ______   ___  '
    echo '  / _ \___ ________ | | / (_)__ _    ______|_  / <  / _ \ / _ \ '
    echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___//_ <_ / / // // // / '
    echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/   /____(_)_/\___(_)___/  '
    echo '================================================================'
    echo
    echo "Please be patient, it may take some time for the job to pass through the queue."
    echo "KEEP THIS TERMINAL OPEN WHILE USING PARAVIEW"
    echo
    echo "Setting environment..." 
    export LD_LIBRARY_PATH=/usr/common/graphics/ParaView/Mesa-7.10.1/lib:/usr/common/usg/openmpi/1.4.1/gnu/lib:/usr/common/usg/python/2.7.1/lib
    export PATH=/usr/common/graphics/ParaView/$PV_VER/bin:/usr/common/usg/openmpi/1.4.1/gnu/bin:$PATH
    ;;

  *)
    echo "ERROR: Unsuported version $PV_VER requested."
    sleep 1d
    ;;

esac

# echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
# echo "PATH=$PATH"

echo "Starting ParaView/$PV_VER $MPI_NP processes on port $PORT..."

mpiexec -np $MPI_NP pvserver --reverse-connection --use-offscreen-rendering --server-port=$PORT --client-host=localhost

echo "mpiexec pvserver exited with code $?. Tunnel to Euclid will now close."
sleep 10s

