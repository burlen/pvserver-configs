#!/bin/bash

if [ $# != 2 ]
then
  echo "Usage: start_pvserver.sh JID JERRF"
  echo
  echo "JID -- job id retruned from qsub"
  echo "JEERF -- full path to stderr file"
  echo
  sleep 1d
fi

JID=$1
JERRF=$2

echo "Starting batch job monitor..."
echo "JID=$JID"
echo "JERRF=$JERRF"
echo
qstat -G $JID
echo

# make sure the job is deleted, if this window closes.
trap "{ qdel $JID; exit 0;  }" EXIT

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
      echo "    c - checkjob $JID."
      echo "    d - delete job $JID."
      echo "    h - print help message."
      echo "    p - pages job $JID's stderr/stdout stream."
      echo "    q - quit, and delete job $JID."
      echo "    s - showq."
      echo "    u - qstat $JID."
      echo "    w - showstart $JID."
      echo
      ;;

    P|p)
      echo
      if [ -e  $JERRF ]
      then
        less $JERRF
      elif [ -e ~/$JID.ER ]
      then
        less  ~/$JID.ER
      else
        echo "Job output is not yet available."
      fi
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

    W|w)
      echo
      showstart $JID
      echo
      ;;

    *)
      echo
      ;;

   esac
done
