# install for spiel stuff
#
# NOTE: The box MUST have >= 4GB of Ram
# otherwise the installation process WILL FAIL
#

# update the server in advance
sudo apt update
sudo apt upgrade

# clone repos
git clone https://github.com/The-Code-In-Sheep-s-Clothing/Spiel-Lang.git
git clone https://github.com/The-Code-In-Sheep-s-Clothing/Spiel-Front.git

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

#
#
#
# TODO NEED TO WRITE IN YOUR OWN SERVER SETUP FOR THIS SITE
# Use the NGINX guide here (https://nginx.org/en/docs/beginners_guide.html), and add a config file to /etc/nginx/sites-available/,
# then sym-link this to sites-enabled (standard practice)
# Must have /api_1/share | test | load | runCode endpoints setup for port (5174)
# Use proxy_pass for this, very easy, direct line
#
#

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
echo "Make a note of the Cert & Key file generated, you will need these to setup HTTPS for React"
echo ""
echo "Hit Enter to continue"
echo ""
read ccc

# build Spiel server
cd Spiel-Lang
stack install
stack build
./release_tools/linux/release.sh
cd ..

# build Spiel front
cd Spiel-Front
npm install
cd ..

echo ""
echo "* Please change the port # in package.json to PORT=XXX react-scripts start"
echo "* Please change the server addr in src/Run/Run.tsx to http://IP:PORT"
echo "Hit Enter to continue"
echo ""
read ccc
vim package.json
vim src/Run/Run.tsx

# start everything up
./fireup