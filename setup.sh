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

# clone repos
git clone https://github.com/The-Code-In-Sheep-s-Clothing/bogl.git
git clone https://github.com/The-Code-In-Sheep-s-Clothing/bogl-editor.git

# setup dev deps
sudo apt install haskell-stack
sudo apt install cabal-install
sudo apt install zlib1g-dev
# get node 12x
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt install npm

# setup nginx for the webserver
sudo apt-get install nginx

# Copy over & setup the nginx config
sudo cp nginx_config/bogl_nginx_config /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/bogl_nginx_config /etc/nginx/sites-enabled/bogl_nginx_config

# certbot setup for TLS certs
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update

# install certbot, optional to setup booting with everything in-tact
sudo apt-get install certbot

# generate a cert
echo ""
echo "Alright, when certbot asks you to set things up, make sure you enter a non-AWS domain."
echo "Any subdomain will work (such as spiel.uphouseworks.com), so long as there is an associated CNAME"
echo "record pointing to this server's domain."
echo ""
echo "Hit Enter to continue"
echo ""
read ccc
sudo certbot certonly --standalone

echo ""
echo "Make a note of the Cert & Key file generated, you will need these to setup HTTPS for the site"
echo ""
echo "Hit Enter to continue"
echo ""
read ccc

# move contents over for site
sudo mkdir -p /var/www/html/bogl
sudo mkdir -p /var/www/html/errors
sudo mkdir -p /var/www/html/bogl/docs
sudo mkdir -p /var/www/html/bogl/editor

sudo cp var/www/html/errors/*.html /var/www/html/errors/

# build everything
./build.sh

# start everything up
mkdir bogl-logs
./boot.sh
