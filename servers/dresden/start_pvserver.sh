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

NCPUS=$1
PORT=$2
PV_VER=`echo $3 | cut -d- -f1`

# this is the recommended version to use on NERSC edison
# when new PV is installed this value needs to be updated
NERSC_PV_VER=4.1.0
if [[ "$PV_VER" != "$NERSC_PV_VER" ]]
then
  echo\
    "WARNING: You're using ParaView ver. $PV_VER. The recommended "\
    "version is ParaView ver. $NERSC_PV_VER"
fi

if [[ ! (-e /usr/common/graphics/xeon/ParaView/$PV_VER/start_pvserver.sh) ]]
then
  PV_INSTALLS=`ls -1 /usr/common/graphics/ParaView/ | grep "[34].[0-9].[0-9]" | cut -d- -f1 | tr '\n' ' '`

  echo
  echo\
    "Error: Version $PV_VER  is not installed. Client and server "\
    "versions must match. You will need to download and install a client "\
    "binary for one of the following installed versions from www.paraview.org "\
    "and try again."
  echo
  echo $PV_INSTALLS
  echo

  sleep 1d
fi

export DISPLAY=:0.0
xhost +

echo 'Starting ParaView...'
/usr/common/graphics/xeon/ParaView/$PV_VER/start_pvserver.sh $NCPUS $PORT 
echo 'Exiting..'
sleep 30s
