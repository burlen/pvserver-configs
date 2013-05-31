#!/bin/bash

if [ $# != 2 ]
then
  echo
  echo "Error: invalid number of arguments"
  echo
  echo "Usage: batchsys_mon job_id job_err_file"
  echo
  sleep 1d
fi

JID=$1
JERRF=$2

# make sure the job is deleted, if this window closes.
trap "{ qdel $JID; exit 0;  }" EXIT

echo
qstat $JID
echo

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
      less $JERRF
      echo
      ;;

    L|l)
      echo
      ls -lah $JERRF
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
      qstat $JID
      echo
      ;;

    *)
      echo
      echo "Invalid command $inchar."
      echo
      ;;
   esac
done
