# Spiel (Full stack for the Spiel implementation of BoGL)
This repo holds all the configuration items that are needed to deploy a running BoGL instance on a machine.

Run **install-spiel.sh** first, then continue.

The following assumes you have **Spiel-Lang** and **Spiel-Front** directories located immediately where the scripts are, and that both have been installed and can be built successfully on the given machine. Both are added as submodules, and can be initialized by running **git submodule init** and **git submodule update**. This will initialize the local config file, and then fetch thte data for that sub-repo.

## Running Scripts
- install-spiel.sh
	- Installs everything you will need on your system to run Haskell, the webserver, React, and more. **Run this first**.
- auto_restart.sh
	- automatically reboots the instance in case it turns off (crashes), or during updates. This is regulated by an addition to your CRON file as so:
- fireup.sh
	- this is responsible for starting up an instance, and making rebuilds and updates for the back and frontend automatically upon starting up
- teardown.sh
	- Shutdown script that looks for an instance of **spielserver** by name, and kills the process. Do not use this if you are running more than one spielserver instance on your machine, but normally this should be just fine.
- update_spielserver.sh
	- Updates the backend system (DEPRECATED)

**fireup.sh** is sufficient to start up *everything* and auto-update, so long as the Spiel-Lang and Spiel-Front repositories are located in the same folder.


## Additional Files
- spiel_server_setup.txt
	- contains some hand written notes on setting up things, this may be helpful if you get stuck or want to make additional changes
- ex_runcmd_bogl_curl.txt
	- provides a drop-in example of making a local **curl** request to test the REST endpoints via a POST request. Handy for verifying things are running before you test out the website directly. 

## CRON file changes
Assuming your home folder is `/home/ubuntu`, you may use the following, and if not make sure to adjust to your home folder accordingly. This sets up a weak monitoring system that will auto reboot in case it crashes out, and logs any restarts.

The next bit restarts once a day to apply new updates (via the fireup script), always pulling from the master.

Together, this forms a crude hands-free production system.
```
# auto reboot every minute
#* * * * * echo "Hello There" > /home/ubuntu/TEST_WORKS.txt
* * * * * /home/ubuntu/./auto_restart.sh >> /home/ubuntu/restarts.log

# shuts down and restarts everything at 3:00 AM PST (the server is 7 hours ahead PST), allows new updates to$
# we'll see if this works or not
0 10 * * * /home/ubuntu/./fireup.sh >> /home/ubuntu/restarts.log
```

## NGINX Configs
The sole bogl config file is used to configure nginx to serve for 'bogl.engr.oregonstate.edu'. This can be adjusted based on your own domain, but is tailored to combine Spiel-Front (front) and Spiel-Lang (backend) together from a user's view. You will want to copy this over to **/etc/nginx/sites-available**, and then create a symbolic link to **/etc/nginx/sites-enabled**.
