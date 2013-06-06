#!/bin/bash

if [ $# != 6 ]
then
  echo "expected 6 argumnets but got $#"
  echo "args:"
  echo $*
  echo
  echo "Usage: start_pvserver.sh NCPUS WALLTIME ACCOUNT PORT"
  echo
  echo "  NCPUS     - number of processes in mutiple of 24."
  echo "  NCPUS_PER_SOCKET - number of processes per socket. 4 sockets per node."
  echo "  WALLTIME  - wall time in HH:MM:SS format."
  echo "  ACCOUNT   - account name to run the job against."
  echo "  QUEUE     - the queue to use."
  echo "  PORT      - the port number of the server side tunnel."
  echo
  echo "assumes a reverse tunel is set up on localhost to the remote site."
  echo
  sleep 1d
fi

NCPUS=$1
NCPUS_PER_SOCKET=$2
NCPUS_PER_NODE=`echo 4*$NCPUS_PER_SOCKET | bc`
NNODES=`echo $NCPUS/$NCPUS_PER_NODE | bc`
(( NNODES = NNODES==0 ? 1 : $NNODES ))
MEM=`echo 32*$NNODES | bc`
WALLTIME=$3
ACCOUNT=$4
if [[ "$ACCOUNT" == "default" ]]
then
  ACCOUNT=`/usr/common/usg/bin/getnim -U $USER -D | cut -d" " -f1`
fi
ACCOUNTS=`/usr/common/usg/bin/getnim -U $USER | cut -d" " -f1 | tr '\n' ' '`
QUEUE=$5
PORT=$6
LOGIN_HOST=`/bin/hostname`
#let LOGIN_PORT=$PORT+1

# need key based auth on hopper
# this test validates 
PUB_ID=`cat ~/.ssh/id_rsa.pub 2>/dev/null || cat ~/.ssh/id_dsa.pub 2>/dev/null`;
grep "$PUB_ID" ~/.ssh/authorized_keys -q;
PUB_ID_UNAUTHORIZED=$?;
if [[ (-z "$PUB_ID") || ($PUB_ID_UNAUTHORIZED == 1) ]];
then
  echo
  echo "Error: Ssh is not configured for public key based auth. "\
       "The key pair must exist in ~/.ssh and be included in "\
       "~/.ssh/authorized_keys"
  echo
  echo "PUB_ID=$PUB_ID"
  echo "PUB_ID_UNAUTHORIZED=$PUB_ID_UNAUTHORIZED"
  echo
  sleep 1d
else
  echo "Ssh is configured for key based auth.";
fi;

PV_HOME=/usr/common/graphics/ParaView/3.14.0-mom-so

# modules envirtonment isn't setup when using the ssh command.
LD_LIBRARY_PATH=$PV_HOME/lib:$PV_HOME/lib/paraview-3.14:/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib/:/usr/common/usg/python/2.7.1/lib:/opt/gcc/mpc/0.8.1/lib:/opt/gcc/mpfr/2.4.2/lib:/opt/gcc/gmp/4.3.2/lib:/opt/gcc/4.6.1/snos/lib64:/opt/moab/6.1.4/lib:/opt/cray/atp/1.4.1/lib:/usr/common/usg/xt-libsci/10.5.01/gnu/lib

CRAY_LD_LIBRARY_PATH=/opt/cray/mpt/5.6.0/gni/mpich2-gnu/47/lib:/opt/cray/rca/1.0.0-2.0401.38656.2.2.gem/lib64:/opt/cray/xpmem/0.1-2.0401.36790.4.3.gem/lib64:/opt/cray/dmapp/3.2.1-1.0401.5983.4.5.gem/lib64:/opt/cray/pmi/4.0.0-1.0000.9282.69.4.gem/lib64:/opt/cray/ugni/4.0-1.0401.5928.9.5.gem/lib64:/opt/cray/udreg/2.3.2-1.0401.5929.3.3.gem/lib64:/opt/cray/libsci/12.0.00/GNU/47/mc12/lib:/opt/cray/mpt/5.6.0/gni/mpich2-pgi/119/lib:/opt/cray/mpt/5.6.0/gni/sma/lib64:/opt/cray/mpt/5.6.0/gni/sma64/lib64

PATH=$PV_HOME/bin:/usr/common/usg/python/2.7.1/bin:/opt/cray/atp/1.4.1/bin:/opt/cray/xt-asyncpe/5.04/bin:/opt/cray/pmi/3.0.0-1.0000.8661.28.2807.gem/bin:/opt/gcc/4.6.1/bin:/usr/common/usg/bin:/usr/common/mss/bin:/usr/common/nsg/bin:/opt/moab/6.1.4/bin:/opt/torque/2.5.9/sbin:/opt/torque/2.5.9/bin:/opt/cray/llm/default/bin:/opt/cray/llm/default/etc:/opt/cray/xpmem/0.1-2.0400.30792.5.6.gem/bin:/opt/cray/dmapp/3.2.1-1.0400.3965.10.63.gem/bin:/opt/cray/ugni/2.3-1.0400.4127.5.20.gem/bin:/opt/cray/udreg/2.3.1-1.0400.3911.5.13.gem/bin:/opt/cray/lustre-cray_gem_s/1.8.4_2.6.32.45_0.3.2_1.0400.6336.8.1-1.0400.30879.1.81/sbin:/opt/cray/lustre-cray_gem_s/1.8.4_2.6.32.45_0.3.2_1.0400.6336.8.1-1.0400.30879.1.81/bin:/opt/cray/MySQL/5.0.64-1.0000.4667.20.1/sbin:/opt/cray/MySQL/5.0.64-1.0000.4667.20.1/bin:/opt/cray/sdb/1.0-1.0400.31073.9.3.gem/bin:/opt/cray/nodestat/2.2-1.0400.29866.4.3.gem/bin:/opt/modules/3.2.6.6/bin:/usr/lpp/mmfs/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:/usr/lib64/jvm/jre/bin:/usr/lib/mit/bin:/usr/lib/mit/sbin:/opt/pathscale/bin:.

NCAT_PATH=/usr/common/graphics/ParaView/nmap-5.51/bin

echo '================================================================'
echo '   ___               _   ___                ____  _______  ___  '
echo '  / _ \___ ________ | | / (_)__ _    ______|_  / <  / / / / _ \ '
echo ' / ___/ _ `/ __/ _ `/ |/ / / -_) |/|/ /___//_ <_ / /_  _// // / '
echo '/_/   \_,_/_/  \_,_/|___/_/\__/|__,__/   /____(_)_/ /_/(_)___/  '
echo '================================================================'
echo
echo "Please be patient, it may take some time for the job to pass through the queue."
echo "KEEP THIS TERMINAL OPEN WHILE USING PARAVIEW"
echo
echo "Setting environment..."
#echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
#echo "PATH=$PATH"
echo "ACCOUNT=$ACCOUNT"
echo "ACCOUNTS=$ACCOUNTS"
echo "NCPUS=$NCPUS"
echo "NCPUS_PER_SOCKET=$NCPUS_PER_SOCKET"
echo "NCPUS_PER_NODE=$NCPUS_PER_NODE"
echo "NNODES=$NNODES"
echo "MEM=$MEM\GB"
echo "WALLTIME=$WALLTIME"
echo "ACCOUNTS=$ACCOUNTS"
echo "ACCOUNT=$ACCOUNT"
echo "PORT=$PORT"
echo "QUEUE=$QUEUE"
echo "LOGIN_HOST=$LOGIN_HOST"
echo "LOGIN_PORT=$LOGIN_PORT"

# don't seem to need this when joining two ssh tunnels
#echo "Forwarding port $LOGIN_PORT to $PORT on $LOGIN_HOST"
#$NCAT_PATH/ncat -l $LOGIIN_HOST $LOGIN_PORT --sh-exec="$NCAT_PATH/ncat localhost $PORT" &

echo "Starting ParaView via qsub..."

# pass these to the script
export PV_NCAT_PATH=$NCAT_PATH
export PV_PORT=$PORT
export PV_NCPUS=$NCPUS
export PV_NCPUS_PER_SOCKET=$NCPUS_PER_SOCKET
export PV_LOGIN_HOST=$LOGIN_HOST
#export PV_LOGIN_PORT=$LOGIN_PORT
JID=`qsub -V -N PV-3.14.0-$PORT  -A $ACCOUNT -q $QUEUE -l mppwidth=$NCPUS -l mppnppn=$NCPUS_PER_NODE -l walltime=$WALLTIME $PV_HOME/start_pvserver.qsub`
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
      less ~/PV-3.14.0-$PORT.e$JIDNO
      echo
      ;;

    L|l)
      echo
      ls -lah ~/PV-3.14.0-$PORT.e$JIDNO
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

