#!/bin/bash

#
# auto_restart.sh
# Used to monitor and automatically restart the boglserver (code name for the bogl server) instance, in case it goes down
# @montymxb
#

# path to setup for cronjob scripts
PATH=/home/ubuntu/.local/bin:/home/ubuntu/.local/bin/stack:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

# Change this to the path of the user's directory
cd /home/ubuntu/bogl-deploy-scripts/

# check if the backend is running
runBack=`ps -e | grep boglserver | wc -l`

if [ $runBack -eq 0 ]; then
	# super fast reboot
	./boot.sh
fi
