# install for BoGL stuff
#
# NOTE: The box MUST have >= 4GB of Ram
# otherwise the installation process WILL FAIL
#

echo ""
echo "This Script will install the stack for running a BoGL language server,"
echo "along with the frontend and all supporting components."
echo ""
echo "What you will need during this process:"
echo "- A valid domain name that you can generate a certificate for (like bogl.engr.oregonstate.edu)"
echo ""
echo "[Hit enter to continue if you're ready]"
read qqq

# update the server in advance
sudo apt update
sudo apt upgrade

# clone repos (bogl, editor, docs)
git clone https://github.com/ChildsplayOSU/bogl.git
git clone https://github.com/ChildsplayOSU/bogl-editor.git
git clone https://github.com/ChildsplayOSU/bogl-docs.git

# setup dev deps
sudo apt install haskell-stack cabal-install zlib1g-dev ruby-bundler ruby-dev g++

# get node 12x
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install nodejs npm nginx

# Copy over & setup the nginx config
sudo cp nginx_config/bogl_nginx_config_httponly /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/bogl_nginx_config_httponly /etc/nginx/sites-enabled/bogl_nginx_config_httponly

# certbot setup for TLS certs
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update

# pre-emptively make this folder so we can use certbot properly
sudo mkdir -p /var/www/html/bogl
sudo mkdir -p /var/www/html/errors
sudo mkdir -p /var/www/html/bogl/docs
sudo mkdir -p /var/www/html/bogl/editor

# boot up nginx
sudo nginx

# install certbot, optional to setup booting with everything in-tact
sudo apt-get install certbot

# generate a cert
echo ""
echo "Alright, when certbot asks you to set things up, make sure you enter a non-AWS domain."
echo "Any subdomain will work (such as bogl.uphouseworks.com), so long as there is an associated CNAME"
echo "record pointing to this server's domain."
echo ""
echo "Hit Enter to continue"
echo ""
read ccc
sudo certbot certonly --webroot --webroot-path /var/www/html/bogl/editor/ --domain bogl.engr.oregonstate.edu

echo ""
echo "Make a note of the Cert & Key file generated, you will need these to setup HTTPS for the site"
echo ""
echo "Hit Enter to continue"
echo ""
read ccc

# remove the old config, using the http one now
sudo rm /etc/nginx/sites-enabled/bogl_nginx_config_httponly
sudo rm /etc/nginx/sites-available/bogl_nginx_config_httponly
sudo cp nginx_config/bogl_nginx_config /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/bogl_nginx_config /etc/nginx/sites-enabled/bogl_nginx_config
sudo service nginx reload

# move contents over for site
sudo cp var/www/html/errors/*.html /var/www/html/errors/

# build everything
./build.sh

# start everything up
mkdir bogl-logs
./boot.sh

# finally, setup the docs
cd bogl-docs
bundle install
