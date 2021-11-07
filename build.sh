#
# build.sh
#

echo "* updating & building bogl & bogl-editor"

# update bogl
cd bogl
git stash
git checkout master
git pull

# update editor
cd ../bogl-editor
git stash
git checkout master
git pull
cd ..

# update docs
cd ../bogl-docs
git stash
git checkout master
git pull
cd ..

# rebuild the backend server first, just in case
cd bogl
./release_tools/linux/release.sh
cd ..

# rebuild the frontend, nginx will auto serve the new content
cd bogl-editor/
npm install
npm run build
sudo cp -r build/* /var/www/html/bogl/editor/
cd ..

# rebuild the docs
cd bogl-docs/
# ensure to run a quick bundle install, in case new deps are present
bundle install
bundle exec jekyll build
sudo rsync -r _site/ /var/www/html/bogl/docs/
cd ..

echo "* build done"
