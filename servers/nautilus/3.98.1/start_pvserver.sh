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
MEM_KB=`echo "$MEM*1024" | bc`
LOGIN_HOST=`/bin/hostname`
let LOGIN_PORT=$PORT+1

export PV_PATH=/sw/analysis/paraview/3.98/sles11.1_intel11.1.038

export LD_LIBRARY_PATH=$PV_PATH/lib/paraview-3.98/:/opt/gcc/4.6.3/lib64:/opt/gcc/4.6.3/lib:/sw/analysis/python/2.7.1/sles11.1_gnu4.3.4/lib:/opt/sgi/mpt/mpt-2.04/lib:/sw/analysis/hdf5/1.8.5/sles11.1_gnu4.3.4/lib:/sw/analysis/netcdf/4.1.1/sles11.1_gnu4.3.4/lib:/sw/analysis/hdf4/4.2.5/sles11.1_gnu4.3.4/lib:/sw/analysis/szip/2.1/sles11.1_gnu4.3.4/lib:/opt/uberftp/2.6-r1/lib:/opt/globus/5.0.4-r1/lib:/opt/torque/4.1.2/lib
export _LD_LIBRARY_PATH=$LD_LIBRARY_PATH

export PATH=$PV_PATH/bin:/sw/analysis/cmake/2.8.8/sles11.1_gnu4.6.3/bin:/opt/gcc/4.6.3/bin:/sw/analysis/python/2.7.1/sles11.1_gnu4.3.4/bin:/opt/sgi/mpt/mpt-2.04/bin:/sw/analysis/netcdf/4.1.1/sles11.1_gnu4.3.4/bin:/sw/analysis/hdf4/4.2.5/sles11.1_gnu4.3.4/bin:/sw/analysis/szip/2.1/sles11.1_gnu4.3.4/bin:/sw/altd/bin:/opt/uberftp/2.6-r1/bin:/opt/tg-policy/0.2-r1/bin:/opt/pacman/3.29-r1/bin:/opt/globus/5.0.4-r1/bin:/opt/globus/5.0.4-r1/sbin:/usr/local/hsi/bin:/usr/local/gold/bin:/opt/moab/6.0.4/bin:/opt/torque/4.1.2/bin:/usr/local/bin:/usr/bin:/bin:/usr/lib/mit/bin:/usr/lib/mit/sbin:/nics/c/home/bloring/bin
export _PATH=$PATH

export NCAT_PATH=/sw/analysis/paraview/.nmap-6.00/install/bin

echo '================================================================'
echo '   ___               _   ___                ____  ___  ___      ' 
echo '  / _ \___ ________ | | / (_)__ _    ______|_  / / _ \( _ ) _/| '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___//_ <_ \_, / _  |> _< '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/   /____(_)___/\___(_)/   '
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
#-v MPI_TYPE_MAX,PV_PATH,_PATH,_LD_LIBRARY_PATH,PV_NCPUS,PV_PORT,PV_LOGIN_HOST,PV_LOGIN_PORT 
export MPI_TYPE_MAX=1000000
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
export PV_LOGIN_HOST=$LOGIN_HOST
export PV_LOGIN_PORT=$LOGIN_PORT
export PV_HOST_MEMORY_LIMIT=$MEM_KB
JID=`qsub -S /bin/bash -V -N PV-3.98-$PORT -A $ACCOUNT -q $QUEUE -l ncpus=$NCPUS,mem=$MEM\MB,walltime=$WALLTIME /sw/analysis/paraview/3.98/sles11.1_intel11.1.038/start_pvserver.qsub`
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
      less ~/PV-3.98-$PORT.e$JIDNO
      echo
      ;;

    L|l)
      echo
      ls -lah ~/PV-3.98-$PORT.e$JIDNO
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

