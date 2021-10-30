#!/bin/bash

# Updates the docs for the bogl website
# Assumes the bogl-docs repo is present here
# The same code is present in the 'build.sh' script, and will run automatically each day

cd ~/bogl-deploy-scripts/bogl-docs/

bundle exec jekyll build
sudo rsync -r _site/ /var/www/html/bogl/docs/
