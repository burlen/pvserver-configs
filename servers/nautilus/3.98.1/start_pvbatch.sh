#!/bin/bash

if [ $# != 6 ]
then
  echo "Usage: start_pvbatch.sh NCPUS WALLTIME ACCOUNT SCRIPT"
  echo
  echo "  NCPUS     - number of processes in mutiple of 8."
  echo "  MEM       - ram per process. each 8 cpus comes with 32GB ram."
  echo "  WALLTIME  - wall time in HH:MM:SS format."
  echo "  ACCOUNT   - your tg account for billing purposes."
  echo "  QUEUE     - the queue to use."
  echo "  SCRIPT    - path to your python batch script."
  echo
  exit 1
fi

NCPUS=$1
MEM=$2
WALLTIME=$3
ACCOUNT=$4
QUEUE=$5
BATCH_SCRIPT_PATH=$6

MEM=`echo "$NCPUS*$MEM*1000" | bc`
LOGIN_HOST=`/bin/hostname`

export PV_PATH=/sw/analysis/paraview/3.98/sles11.1_intel11.1.038

export LD_LIBRARY_PATH=$PV_PATH/lib/paraview-3.98/:/opt/gcc/4.6.3/lib64:/opt/gcc/4.6.3/lib:/sw/analysis/python/2.7.1/sles11.1_gnu4.3.4/lib:/opt/sgi/mpt/mpt-2.04/lib:/sw/analysis/hdf5/1.8.5/sles11.1_gnu4.3.4/lib:/sw/analysis/netcdf/4.1.1/sles11.1_gnu4.3.4/lib:/sw/analysis/hdf4/4.2.5/sles11.1_gnu4.3.4/lib:/sw/analysis/szip/2.1/sles11.1_gnu4.3.4/lib:/opt/uberftp/2.6-r1/lib:/opt/globus/5.0.4-r1/lib:/opt/torque/4.1.2/lib
export _LD_LIBRARY_PATH=$LD_LIBRARY_PATH

export PATH=$PV_PATH/bin:/sw/analysis/cmake/2.8.8/sles11.1_gnu4.6.3/bin:/opt/gcc/4.6.3/bin:/sw/analysis/python/2.7.1/sles11.1_gnu4.3.4/bin:/opt/sgi/mpt/mpt-2.04/bin:/sw/analysis/netcdf/4.1.1/sles11.1_gnu4.3.4/bin:/sw/analysis/hdf4/4.2.5/sles11.1_gnu4.3.4/bin:/sw/analysis/szip/2.1/sles11.1_gnu4.3.4/bin:/sw/altd/bin:/opt/uberftp/2.6-r1/bin:/opt/tg-policy/0.2-r1/bin:/opt/pacman/3.29-r1/bin:/opt/globus/5.0.4-r1/bin:/opt/globus/5.0.4-r1/sbin:/usr/local/hsi/bin:/usr/local/gold/bin:/opt/moab/6.0.4/bin:/opt/torque/4.1.2/bin:/usr/local/bin:/usr/bin:/bin:/usr/lib/mit/bin:/usr/lib/mit/sbin:/nics/c/home/bloring/bin
export _PATH=$PATH

export NCAT_PATH=/sw/analysis/paraview/.nmap-6.00/install/bin

# intel build
#export PV_PATH=/sw/analysis/paraview/3.98/sles11.1_intel11.1.038
#
#export LD_LIBRARY_PATH=$PV_PATH/lib/paraview-3.98/:/sw/analysis/python/2.7.1/sles11.1_intel11.1/lib:/opt/sgi/mpt/mpt-2.04/lib:/opt/intel/Compiler/11.1/038/lib/intel64:/opt/intel/Compiler/11.1/038/mkl/lib/em64t:/opt/intel/Compiler/11.1/038/ipp/em64t/lib:/opt/intel/Compiler/11.1/038/tbb/em64t/cc4.1.0_libc2.4_kernel2.6.16.21/lib:/opt/torque/3.0.3/lib
#
#export PATH=$PV_PATH/bin:/sw/analysis/python/2.7.1/sles11.1_intel11.1/bin:/opt/sgi/mpt/mpt-2.04/bin:/sw/analysis/git/1.7.6/sles11.1_intel11.1/bin:/nics/e/sw/tools/bin:/usr/local/hsi/bin:/usr/local/gold/bin:/opt/intel/Compiler/11.1/038/bin/intel64:/opt/moab/6.0.4/bin:/opt/torque/3.0.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/lib/mit/bin:/usr/lib/mit/sbin

echo '=========================================================='
echo '   ___ _   _____       __      __      ____  ___  ___     '
echo '  / _ \ | / / _ )___ _/ /_____/ / ____|_  / / _ \( _ ) _/|'
echo ' / ___/ |/ / _  / _ `/ __/ __/ _ \___//_ <_ \_, / _  |> _<'
echo '/_/   |___/____/\_,_/\__/\__/_//_/  /____(_)___/\___(_)/  '
echo '=========================================================='
echo
echo "Setting environment..."
#echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
#echo "PATH=$PATH"
echo "ACCOUNT=$ACCOUNT"
echo "NCPUS=$NCPUS"
echo "MEM=$MEM\MB"
echo "WALLTIME=$WALLTIME"
echo "QUEUE=$QUEUE"
echo "LOGIN_HOST=$LOGIN_HOST"
echo "BATCH_SCRIPT_PATH=$BATCH_SCRIPT_PATH"
echo
echo "Starting ParaView in batch mode via qsub..."

# pass these to the script
export MPI_TYPE_MAX=1000000
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
export PV_LOGIN_HOST=$LOGIN_HOST
export PV_BATCH_SCRIPT_PATH=$BATCH_SCRIPT_PATH

JID=`qsub -S /bin/bash -v MPI_TYPE_MAX,PV_PATH,PATH,LD_LIBRARY_PATH,PV_NCPUS,PV_LOGIN_HOST,PV_BATCH_SCRIPT_PATH -N PV-3.98-Batch -A $ACCOUNT -q $QUEUE -l ncpus=$NCPUS,mem=$MEM\MB,walltime=$WALLTIME /sw/analysis/paraview/3.98/sles11.1_intel11.1.038/start_pvbatch.qsub`
ERRNO=$?
if [ $ERRNO == 0 ] 
then
echo "Job $JID submitted succesfully."
else
echo "ERROR $ERRNO: in job submission."
fi

exit 0
