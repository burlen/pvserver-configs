#!/bin/bash

if [ $# != 8 ]
then
  echo "expected 8 argumnets but got $#"
  echo "args:"
  echo $*
  echo
  echo "Usage: start_pvserver.sh"
  echo
  echo "  NCPUS     - number of processes in mutiple of 24."
  echo "  NCPUS_PER_SOCKET - number of processes per socket. 2 sockets per node."
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
export NERSC_HOST=edison

NCPUS=$1
NCPUS_PER_SOCKET=$2
WALLTIME=$3
ACCOUNT=$4
QUEUE=$5
PORT=$6
PV_VER=$7
LINK=$8

# if python support requested then use the DSO install
# else use the static linked install, it starts much faster.
# new pv installs must have both DSO and static
HAVE_STATIC=0
HAVE_SHARED=0
HAVE_HYBRID=0
if [[ -e /usr/common/graphics/ParaView/$PV_VER/static/start_pvserver.sh ]]
then
  HAVE_STATIC=1
fi
if [[ -e /usr/common/graphics/ParaView/$PV_VER/shared/start_pvserver.sh ]]
then
  HAVE_SHARED=1
fi
if [[ -e /usr/common/graphics/ParaView/$PV_VER/hybrid/start_pvserver.sh ]]
then
  HAVE_HYBRID=1
fi
# to support old installs that don't have all the link types
if [[ "$LINK" == "0" ]]
then
  if [[ "$HAVE_STATIC" == "1" ]]
  then
    PV_LINK=static
  elif [[ "$HAVE_HYBRID" == "1" ]]
  then
    PV_LINK=hybrid
  elif [[ "$HAVE_SHARED" == "1" ]]
  then
    PV_LINK=shared
  else
    PV_LINK=none
  fi
fi
if [[ "$LINK" == "1" ]]
then
  if [[ "$HAVE_SHARED" == "1" ]]
  then
    PV_LINK=shared
  elif [[ "$HAVE_HYBRID" == "1" ]]
  then
    PV_LINK=hybrid
  elif [[ "$HAVE_STATIC" == "1" ]]
  then
    PV_LINK=static
  else
    PV_LINK=none
  fi
fi
if [[ "$LINK" == "2" ]]
then
  if [[ "$HAVE_HYBRID" == "1" ]]
  then
    PV_LINK=hybrid
  elif [[ "$HAVE_SHARED" == "1" ]]
  then
    PV_LINK=shared
  elif [[ "$HAVE_STATIC" == "1" ]]
  then
    PV_LINK=static
  else
    PV_LINK=none
  fi
fi

# this is the recommended version to use on NERSC edison
# when new PV is installed this value needs to be updated
NERSC_PV_VER=4.1.0
if [[ "$PV_VER" != "$NERSC_PV_VER" ]]
then
  echo\
    "WARNING: You're using ParaView ver. $PV_VER. The recommended "\
    "version is ParaView ver. $NERSC_PV_VER"
fi

if [[ ! (-e /usr/common/graphics/ParaView/$PV_VER/$PV_LINK/start_pvserver.sh) ]]
then
  PV_INSTALLS=`ls -1 /usr/common/graphics/ParaView/ | grep "[34].[0-9].[0-9]" | cut -d- -f1 | tr '\n' ' '`

  echo
  echo\
    "Error: Version $PV_VER ($PV_LINK) is not installed. Client and server "\
    "versions must match. You will need to download and install a client "\
    "binary for one of the following installed versions from www.paraview.org "\
    "and try again."
  echo
  echo $PV_INSTALLS
  echo

  sleep 1d
fi

/usr/common/graphics/ParaView/$PV_VER/$PV_LINK/start_pvserver.sh $NCPUS $NCPUS_PER_SOCKET $WALLTIME $ACCOUNT $QUEUE $PORT
sleep 1d
