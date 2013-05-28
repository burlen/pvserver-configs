#!/bin/bash

if [ $# != 4 ]
then
  echo "Usage: start_pvtest.sh NCPUS WALLTIME ACCOUNT PORT"
  echo
  echo "  SCRIPT    - cmake test script"
  echo "  ACCOUNT   - account."
  echo "  WALLTIME  - wall time in HH:MM:SS format."
  echo "  QUEUE     - the queue to use."
  echo
  sleep 1d
fi

SCRIPT=$1
ACCOUNT=$2
WALLTIME=$3
QUEUE=$4

echo "SCRIPT=$SCRIPT"
echo "ACCOUNT=$ACCOUNT"
echo "WALLTIME=$WALLTIME"
echo "QUEUE=$QUEUE"

export PV_TEST_HOME=/usr/common/graphics/ParaView/dashboards
export PV_TEST_SCRIPT=$PV_TEST_HOME/gcc-mpt-py-osmesa.cmake

source /usr/common/graphics/ParaView/dashboards/modules-gnu.sh

#export PV_LOGIN_PORT=$LOGIN_PORT
JID=`qsub -V -N pv-ctests-ed -q $QUEUE -A $ACCOUNT -l mppwidth=16 -l mppnppn=16 -l walltime=$WALLTIME $PV_TEST_HOME/start_pvtest.qsub`
ERRNO=$?
if [ $ERRNO == 0 ]
then
echo "Job submitted succesfully."
else
echo "ERROR $ERRNO: in job submission."
fi
