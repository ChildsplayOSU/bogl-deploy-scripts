#!/bin/bash

#
# Rebuilds & Reboots a BoGL Instance (CRON script)
# Last Updated Feb. 26th, 2021
# Benjamin Wilson
# @montymxb
#

# path to setup for cronjob scripts
PATH=/home/ubuntu/.local/bin:/home/ubuntu/.local/bin/stack:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

cd /home/ubuntu/bogl-deploy-scripts/

# check if the backend is already running
runBack=`ps -e | grep spielserver | wc -l`

if [ $runBack -eq 1 ]; then
	# stop running instances
	./teardown.sh
	# wait a moment to continue
	echo ""
	echo "* Stopped existing spielserver instance, waiting 5 seconds to continue..."
	sleep 5
fi

./build.sh
echo "* Rebuilding"

# run and background the webserver
echo "* Rebooting & Backgrounding spielserver w/ logs..."
./boot.sh

echo "* Done"
