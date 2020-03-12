set -e

PROJECT_NAME=celestial-pi0w
IMAGE_NAME=core-image-base
TIMESTAMP=$(date +"%Y%d%m%H%M%S")
RELEASE_HEADER="${PROJECT_NAME}_${IMAGE_NAME}_${TIMESTAMP}"
if [ ! -n $RELEASE_UID ]; then
  RELEASE_HEADER="${RELEASE_HEADER}_${RELEASE_UID}"
fi

export BITBAKEDIR=/app/oe/sources/poky/bitbake
# Set up the build directory as a symlink to /tmp
mkdir -p "/tmp/build/$PROJECT_NAME"
ln -s "/tmp/build/$PROJECT_NAME" "/app/oe/${PROJECT_NAME}-build"
cp -r /app/oe/build/* "/app/oe/${PROJECT_NAME}-build"

# Build the image
source /app/oe/sources/poky/oe-init-build-env "${PROJECT_NAME}-build"
bitbake "$IMAGE_NAME"

# Package the deploy directory
mv "/app/oe/${PROJECT_NAME}-build/tmp/deploy" /app/oe/deploy
cd /app/oe
tar -zcf "/mnt/deploy/${RELEASE_HEADER}_deploy.tar.gz" deploy

