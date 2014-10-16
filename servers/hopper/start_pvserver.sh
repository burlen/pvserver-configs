#!/bin/bash

if [[ $# < 7 ]]
then
  echo "expected 7 argumnets but got $#"
  echo
  echo "You may need to update your server config (pvsc) files. The latest "
  echo "server config may be found at: https://www.nersc.gov/users/software/vis-analytics/paraview"
  echo
  echo "args:"
  echo $*
  echo
  echo "Usage: start_pvserver.sh"
  echo
  echo "  NCPUS     - number of processes in mutiple of 24."
  echo "  NCPUS_PER_SOCKET - number of processes per socket. 4 sockets per node."
  echo "  WALLTIME  - wall time in HH:MM:SS format."
  echo "  ACCOUNT   - account name to run the job against."
  echo "  QUEUE     - the queue to use."
  echo "  PORT      - the port number of the server side tunnel."
  echo "  PV_VER    - the desired pv version number."
  echo "  PYTHON    - if set use python enabled build."
  echo
  echo "assumes a reverse tunel is set up on localhost to the remote site."
  echo
  sleep 1d
fi
export NERSC_HOST=hopper

NCPUS=$1
NCPUS_PER_SOCKET=$2
WALLTIME=$3
ACCOUNT=$4
QUEUE=$5
PORT=$6
PV_VER=$7
USE_PY=$8

#workaround bug in 4.2.0 release version
PV_VER=`echo $PV_VER | cut -d- -f1`

# with 4.2.0 python can be included in static linked builds
# this means we no longer need two installs!! The following
# logic should be removed when the 4.1 install is no longer
# needed. starting with 4.2 it's no longer a user option in
# our pvsc.

# if python then use the shared library
# build
PV_LIB_EXT=so
if [[ "$USE_PY" == "0" ]]
then
  PV_LIB_EXT=a
fi

if [[ ! (-e /usr/common/graphics/ParaView/$PV_VER-mom-$PV_LIB_EXT/start_pvserver.sh) ]]
then
  PV_PY_INSTALLS=`ls -1 /usr/common/graphics/ParaView/ | grep mom-so | cut -d- -f1 | tr '\n' ' '`
  PV_INSTALLS=`ls -1 /usr/common/graphics/ParaView/ | grep mom-a | cut -d- -f1 | tr '\n' ' '`

  haspystr=" with "
  if [[ "$USE_PY" == "0" ]]
  then
    haspystr=" without "
  fi

  echo
  echo\
    "Error: Version $PV_VER $haspystr python is not installed. Client and "\
    "server versions must match. You will need to download and install a "\
    "client binary for one of the following installed versions from "\
    "www.paraview.org and try again."
  echo
  echo "installs with python enabled"
  echo $PV_PY_INSTALLS
  echo
  echo "installs with out python enabled"
  echo $PV_INSTALLS
  echo
  echo\
    "note: python enabled installs use DSOs which have increased startup "\
    "overhad."
  echo

  sleep 1d
fi

NERSC_PV_VER=4.1.0
if [ "$PV_VER" != "$NERSC_PV_VER" ]
then
  echo
  echo "WARNING: You are using ParaView $PV_VER. This is not the recommnded version."
  echo
fi

/usr/common/graphics/ParaView/$PV_VER-mom-$PV_LIB_EXT/start_pvserver.sh $NCPUS $NCPUS_PER_SOCKET $WALLTIME $ACCOUNT $QUEUE $PORT
