#!/bin/bash

#
# boot-server.sh
# Boots the server, stopping any prior server instances before
#
# Added Feb. 26th, 2021
# Benjamin Wilson
# @montymxb
#

# super lazy kill, just stops anything that matches the term 'spielserver'
# this is very crude, but works rather simply
# NOTE: This assumes the user is 'ubuntu', change as necessary
kill `ps -U ubuntu | grep -E "spielserver"`

dt=`date +"%F-%T"`
./bogl/spielserver 5174 > bogl-logs/spielserver_log_$dt.log 2>&1 &
