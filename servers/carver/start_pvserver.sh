#!/bin/bash -l

if [ $# != 8 ]
then
  echo "expected 8 argumnets but got $#"
  echo "args:"
  echo $*
  echo
  echo "Usage: start_pvserver.sh"
  echo
  echo "  NNODES        - number of compute nodes each with 8 cores."
  echo "  NCPU_PER_NODE - number of processes per node (1-8)."
  echo "  NODE_TYPE     - type of node, small, big, xl"
  echo "  WALLTIME      - wall time in HH:MM:SS format."
  echo "  ACCOUNT       - account name to run the job against."
  echo "  QUEUE         - the queue to use."
  echo "  PORT          - the port number of the server side tunnel."
  echo "  PV_VER        - the desired pv version number."
  echo
  echo "assumes a reverse tunel is set up on localhost to the remote site."
  echo
  sleep 1d
fi
export NERSC_HOST=carver
export CHOS=sl6carver

NNODES=$1
NCPUS_PER_NODE=$2
NODE_TYPE=$3
WALLTIME=$4
ACCOUNT=$5
QUEUE=$6
PORT=$7
PV_VER=`echo $8 | cut -d- -f1`


# this is the recommended version to use on NERSC carver
# when new PV is installed this value needs to be updated
NERSC_PV_VER=4.1.0
if [[ "$PV_VER" != "$NERSC_PV_VER" ]]
then
  echo\
    "WARNING: You're using ParaView ver. $PV_VER. The recommended "\
    "version is ParaView ver. $NERSC_PV_VER"
fi

if [[ ! (-e /usr/common/graphics/ParaView/$PV_VER/start_pvserver.sh) ]]
then
  PV_INSTALLS=`ls -1 /usr/common/graphics/ParaView/ | grep "[34].[0-9].[0-9]" | cut -d- -f1 | tr '\n' ' '`
  echo
  echo\
    "Error: Version $PV_VER is not installed. Client and server "\
    "versions must match. You will need to download and install "\
    "a client binary for one of the following installed versions "\
    "from www.paraview.org and try again."
  echo
  echo $PV_INSTALLS
  echo

  sleep 1d
fi

/usr/common/graphics/ParaView/$PV_VER/start_pvserver.sh $NNODES $NCPUS_PER_NODE $NODE_TYPE $WALLTIME $ACCOUNT $QUEUE $PORT
sleep 1d
