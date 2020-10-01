#!/bin/bash

#
# auto_restart.sh
# Used to monitor and automatically restart the spielserver instance, in case it goes down
#

cd /home/ubuntu

# check if the backend is running
runBack=`ps -e | grep spielserver | wc -l`

# check if the frontend is running
# runFront=`ps -e | grep node | wc -l`
# || [ $runFront -eq 0 ]

if [ $runBack -eq 0 ]; then
	# super fast reboot of the instance
	dt=`date +"%F-%T"`
	./Spiel-Lang/spielserver 5174 > spielserver_log_$dt.log 2>&1 &
fi

