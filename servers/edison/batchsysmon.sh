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
squeue -j $JID
echo

# make sure the job is deleted, if this window closes.
trap "{ scancel $JID; exit 0;  }" EXIT


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
      echo "    u - squeue $JID."
      echo "    d - delete job $JID and exit."
      echo "    p - pages job $JID's stderr/stdout stream."
      echo "    h - print help message."
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
      echo "deleting $JID"
      echo "goodbye!"
      sleep 15s
      exit 0
      ;;

    U|u)
      echo
      squeue -j $JID
      echo
      ;;

    *)
      echo
      echo "Invalid command $inchar."
      echo
      ;;
   esac
done
