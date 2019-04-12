export BITBAKEDIR=/app/oe/sources/poky/bitbake
mkdir -p /tmp/build/celestial-pi3
ln -s /tmp/build/celestial-pi3 /app/oe/celestial-pi3-build
cp -r /app/oe/build/* /app/oe/celestial-pi3-build
source /app/oe/sources/poky/oe-init-build-env celestial-pi3-build
bitbake rpi-basic-image
