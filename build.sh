#
# build.sh
#

echo "* updating & building bogl & bogl-editor"

# update existing instances
cd bogl
git stash
git checkout master
git pull

cd ../bogl-editor
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
npm run build

echo "* build done"
