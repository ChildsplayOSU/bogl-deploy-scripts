#!/bin/bash

#
# update_spielserver.sh
# Updates the backend, whilst leaving the frontend running
# Allows quick realtime updates to be applied
#

#echo ""
#echo "Please run this from 'screen', otherwise you may encounter issues with the instance staying running on exit"
#echo ""
#read rrr

# update spiel
cd Spiel-Lang
git stash
git checkout master
git pull

cd ..


# stop the running server
kill `ps -U ubuntu | grep -E "spielserver"`

# rebuild the binary
cd Spiel-Lang
./release_tools/linux/release.sh
cd ..

# reboot the new server
./Spiel-Lang/spielserver 5174 &

echo ""
echo "Redeploy Done"
echo ""
curl http://localhost:5168/api_1/test/
