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
export NERSC_HOST=cori

NCPUS=$1
NCPUS_PER_SOCKET=$2
WALLTIME=$3
ACCOUNT=$4
QUEUE=$5
PORT=$6
PV_VER=`echo $7 | cut -d- -f1`
LINK=$8

# a sanity check, because aprun doesn't handle this gracefully
if [[ $NCPUS_PER_SOCKET -gt $NCPUS ]]
then
  echo "WARNING! NCPUS_PER_SOCKET must be less than or equal to NCPUS"
  echo "setting NCPUS_PER_SOCKET=$NCPUS"
  NCPUS_PER_SOCKET=$NCPUS
fi

# this is the recommended version to use on NERSC edison
# when new PV is installed this value needs to be updated
NERSC_PV_VER=5.3.0
if [[ "$PV_VER" != "$NERSC_PV_VER" ]]
then
  echo\
    "WARNING: You're using ParaView ver. $PV_VER. The recommended "\
    "version is ParaView ver. $NERSC_PV_VER"
fi

echo `ls -1 /usr/common/software/ParaView/ | grep "[3456].[0-9].[0-9]"`
echo `pwd`

if [[ ! (-e /usr/common/software/ParaView/$PV_VER/start_pvserver.sh) ]]
then
  PV_INSTALLS=`ls -1 /usr/common/software/ParaView/ | grep "[345].[0-9].[0-9]" | tr '\n' ' '`

  echo
  echo\
    "Error: Version $PV_VER is not installed. Client and server "\
    "versions must match. You will need to download and install a client "\
    "binary for one of the following installed versions from www.paraview.org "\
    "and try again."
  echo
  echo $PV_INSTALLS
  echo
  echo "/usr/common/software/ParaView/$PV_VER/start_pvserver.sh"

  sleep 1d
fi

/usr/common/software/ParaView/$PV_VER/start_pvserver.sh $NCPUS $NCPUS_PER_SOCKET $WALLTIME $ACCOUNT $QUEUE $PORT
echo "Job has exited. Goodbye!"
sleep 15s
