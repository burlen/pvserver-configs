#!/bin/bash

if [ $# != 8 ]
then
  echo "expected 8 argumnets but got $#"
  echo "args:"
  echo $*
  echo
  echo "Usage: start_pvserver.sh"
  echo
  echo "  NCPUS     - number of processes in mutiple of 32."
  echo "  NCPUS_PER_SOCKET - number of processes per socket. 2 sockets per node."
  echo "  NRENDER_THREADS - number of rendering threads per process."
  echo "  WALLTIME  - wall time in HH:MM:SS format."
  echo "  ACCOUNT   - account name to run the job against."
  echo "  QUEUE     - the queue to use."
  echo "  PORT      - the port number of the server side tunnel."
  echo "  PV_VER    - the desired pv version number."
  echo
  echo "assumes a reverse tunel is set up on localhost to the remote site."
  echo
  sleep 1d
fi
export NERSC_HOST=hopper

NCPUS=$1
NCPUS_PER_SOCKET=$2
NRENDER_THREADS=$3
WALLTIME=$4
ACCOUNT=$5
QUEUE=$6
PORT=$7
PV_VER=$8

if [[ ! (-e /usr/common/graphics/ParaView/$PV_VER/start_pvserver.sh) ]]
then
  PV_INSTALLS=`ls -1 /usr/common/graphics/ParaView/ | grep mom-so | cut -d- -f1 | tr '\n' ' '`

  echo
  echo\
    "Error: Version $PV_VER is not installed. Client and server versions "\
    "must match. You will need to download and install a client biinary "\
    "for one of the following installed versions from www.paraview.org "\
    "and try again."
  echo
  echo $PV_INSTALLS
  echo

  sleep 1d
fi

/usr/common/graphics/ParaView/$PV_VER/start_pvserver.sh $NCPUS $NCPUS_PER_SOCKET $NRENDER_THREADS $WALLTIME $ACCOUNT $QUEUE $PORT
sleep 1d
