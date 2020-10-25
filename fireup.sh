#!/bin/bash

# path to help cronjob scripts
PATH=/home/ubuntu/.local/bin:/home/ubuntu/.local/bin/stack:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

cd /home/ubuntu

# check if the backend is running
runBack=`ps -e | grep spielserver | wc -l`

# check if the frontend is running
#runFront=`ps -e | grep node | wc -l`

if [ $runBack -eq 1 ]; then
	# stop running instances
	./teardown.sh
	# wait a moment to continue
	echo ""
	echo "Torn down existing instance, waiting 5 seconds to continue..."
	sleep 5
fi

# update existing instances
cd Spiel-Lang
git stash
git checkout master
git pull
cd ../Spiel-Front
git stash
git checkout master
git pull
cd ..

# rebuild the backend server first, just in case
cd Spiel-Lang
./release_tools/linux/release.sh
cd ..

# run and background the webserver
dt=`date +"%F-%T"`
./Spiel-Lang/spielserver 5174 > spielserver_log_$dt.log 2>&1 &

# rebuild the frontend, nginx will auto serve the new content
cd Spiel-Front/
# verify all new packages are downloaded before a build is attempted
npm install
npm run build
