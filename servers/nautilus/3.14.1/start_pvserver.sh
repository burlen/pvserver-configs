#!/bin/bash

if [ $# != 6 ]
then
  echo "Usage: start_pvserver.sh NCPUS WALLTIME ACCOUNT PORT"
  echo
  echo "  NCPUS     - number of processes in mutiple of 8."
  echo "  MEM       - ram per process. each 8 cpus comes with 32GB ram."
  echo "  WALLTIME  - wall time in HH:MM:SS format."
  echo "  ACCOUNT   - your tg account for billing purposes."
  echo "  QUEUE     - the queue to use."
  echo "  PORT      - the port number of the server side tunnel."
  echo 
  echo "assumes a reverse tunel is set up on localhost to the remote site."
  echo
  sleep 1d
fi

NCPUS=$1
MEM=$2
WALLTIME=$3
ACCOUNT=$4
QUEUE=$5
PORT=$6
MEM=`echo "$NCPUS*$MEM*1000" | bc`
LOGIN_HOST=`/bin/hostname`
let LOGIN_PORT=$PORT+1

export PV_PATH=/sw/analysis/paraview/3.14.1/sles11.1_intel11.1.038

export LD_LIBRARY_PATH=$PV_PATH/lib/paraview-3.14/:/sw/analysis/python/2.7.1/sles11.1_intel11.1/lib:/opt/sgi/mpt/mpt-2.04/lib:/opt/intel/Compiler/11.1/038/lib/intel64:/opt/intel/Compiler/11.1/038/mkl/lib/em64t:/opt/intel/Compiler/11.1/038/ipp/em64t/lib:/opt/intel/Compiler/11.1/038/tbb/em64t/cc4.1.0_libc2.4_kernel2.6.16.21/lib:/opt/torque/3.0.3/lib

export PATH=$PV_PATH/bin:/sw/analysis/python/2.7.1/sles11.1_intel11.1/bin:/opt/sgi/mpt/mpt-2.04/bin:/sw/analysis/git/1.7.6/sles11.1_intel11.1/bin:/nics/e/sw/tools/bin:/usr/local/hsi/bin:/usr/local/gold/bin:/opt/intel/Compiler/11.1/038/bin/intel64:/opt/moab/6.0.4/bin:/opt/torque/3.0.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/lib/mit/bin:/usr/lib/mit/sbin

export NCAT_PATH=$PV_PATH/bin

echo '================================================================'
echo '   ___               _   ___                ____  _______  ___  '
echo '  / _ \___ ________ | | / (_)__ _    ______|_  / <  / / / <  /  '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___//_ <_ / /_  _/ / /   '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/   /____(_)_/ /_/(_)_/    '
echo '================================================================'
echo 
echo "Please be patient, it may take some time for the job to pass through the queue."
echo "KEEP THIS TERMINAL OPEN WHILE USING PARAVIEW"
echo
echo "Setting environment..."
#echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
#echo "PATH=$PATH"
echo "ACCOUNT=$ACCOUNT"
echo "NCPUS=$NCPUS"
echo "MEM=$MEM\MB"
echo "WALLTIME=$WALLTIME"
echo "PORT=$PORT"
echo "QUEUE=$QUEUE"
echo "LOGIN_HOST=$LOGIN_HOST"
echo "LOGIN_PORT=$LOGIN_PORT"

echo "Forwarding port $LOGIN_PORT to $PORT on $LOGIN_HOST"
$NCAT_PATH/ncat -l $LOGIN_HOST $LOGIN_PORT --sh-exec="$NCAT_PATH/ncat localhost $PORT" &

echo "Starting ParaView via qsub..."

# pass these to the script
export MPI_TYPE_MAX=1000000
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
export PV_LOGIN_HOST=$LOGIN_HOST
export PV_LOGIN_PORT=$LOGIN_PORT
JID=`qsub -S /bin/bash -v MPI_TYPE_MAX,PV_PATH,PATH,LD_LIBRARY_PATH,PV_NCPUS,PV_PORT,PV_LOGIN_HOST,PV_LOGIN_PORT -N PV-3.14.1-$PORT -A $ACCOUNT -q $QUEUE -l ncpus=$NCPUS,mem=$MEM\MB,walltime=$WALLTIME /sw/analysis/paraview/3.14.1/sles11.1_intel11.1.038/start_pvserver.qsub`
ERRNO=$?
if [ $ERRNO == 0 ] 
then
echo "Job submitted succesfully."
else
echo "ERROR $ERRNO: in job submission."
fi

# make sure the job is deleted, if this window closes.
trap "{ qdel $JID; exit 0;  }" EXIT

JIDNO=`echo $JID | cut -d. -f1`

# keep the shell open
while :
do
  echo "Enter command (h for help):"
  echo
  echo -n "$"
  read -n 1 inchar
  case $inchar in
    H|h)
      echo
      echo "    u - qstat $JID."
      echo "    s - showq."
      echo "    c - checkjob $JID."
      echo "    d - delete job $JID."
      echo "    q - quit, and delete job $JID."
      echo "    p - pages job $JID's stderr/stdout stream."
      echo "    l - ls job $JID's stderr/stdout file."
      echo "    h - print help message."
      echo
      ;;

    P|p)
      echo
      less ~/PV-3.14.1-$PORT.e$JIDNO
      echo
      ;;

    L|l)
      echo
      ls -lah ~/PV-3.14.1-$PORT.e$JIDNO
      echo
      ;;

    D|d)
      echo
      qdel $JID
      echo
      ;;

    Q|q)
      echo
      qdel $JID
      exit 0
      ;;

    C|c)
      echo
      checkjob $JID
      echo
      ;;

    S|s)
      echo
      showq
      echo
      ;;

    U|u)
      echo
      qstat -G $JID
      echo
      ;;

    *)
      echo
      echo "Invalid command $inchar."
      echo
      ;;
   esac
done

