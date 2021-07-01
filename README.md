# BoGL Deploy Scripts

Bash scripts for installing and managing a BoGL stack. NGINX configuration for serving backend & frontend as a unified system. Additional asset files to copy over to set up a new system from scratch.

## Purpose

This repo (and this document) include the materials and the steps outlined below to create a BoGL stack on a Unix-based system from scratch (with an implicit emphasis on Ubuntu).

## Installing

First clone this repo on the machine you wish to build a system on.
```
git clone https://github.com/The-Code-In-Sheep-s-Clothing/bogl-deploy-scripts.git
```

Run `./setup.sh`. This will install all necessary dependencies, and setup most of the environment you need to have the BoGL server work. This will also get an initial server running.

Then add the following lines to your cronfile (using `crontab -e`). Adjust the paths accordingly for wherever you installed the scripts. These will check to keep the instance alive, and will automatically stop, update, and reboot once a day.
```bash
# auto reboot every minute
* * * * * /home/ubuntu/bogl-deploy-scripts/./auto_restart.sh >> /home/ubuntu/bogl-restarts.log

# shuts down and restarts everything at 3:00 AM PST (our server is 7 hours ahead PST)
# allows new updates to reach the server overnight, keeps it fresh
# NOTE: Depending on your time zone you may need to adjust the time here
0 10 * * * /home/ubuntu/bogl-deploy-scripts/./rebuild-reboot.sh >> /home/ubuntu/bogl-restarts.log
```

At this point you may have to make adjustments to `/etc/nginx/sites-available/bogl_nginx_config` to ensure that the domain you are using is being properly referenced, as well as the TLS certs (which you should note while running `setup.sh`) that you will need to update for your domain. This file was created when you ran the `setup.sh` script, and is used by `nginx` to manage serving of the backend and frontend.

Whenever you make a change to the nginx config, run `sudo nginx -s reload` to apply your changes.

If you are not using TLS/SSL, you can turn this by using the last `server` block, changing the port to 80 on both parts (without ssl), and removing the ssl cert & key elements.

## Explanation of the Scripts
- setup.sh
	- Installs everything you will need on your system to run Haskell, the webserver, React, and more. **Run this first, once**.
- auto_restart.sh
	- automatically reboots the instance in case it turns off (crashes), or during updates. This is used by your CRON script.
- rebuild-reboot.sh
	- this is responsible for rebuilding the front & backend, and rebooting the server. This is used by your CRON script (but you can also manually trigger a build-boot sequence when you want).
- teardown.sh
	- Shutdown script that looks for an instance of **boglserver** by name, and kills the process. Do not use this if you are running more than one boglserver instance on your machine, but normally this should be just fine.

**rebuild-reboot.sh** is sufficient to start up *everything* and auto-update, so long as the bogl and bogl-editor repositories are located in the same folder.
