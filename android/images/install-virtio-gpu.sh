#!/bin/sh
# refer to homepage https://virgil3d.github.io/
# Repos: http://cgit.freedesktop.org/virglrenderer
#

VIRGLRENDERER_PATH=./virtio-gpu

# install dependencies
sudo apt-get install -y libepoxy-dev libfdt-dev libgbm-dev libgles2-mesa-dev \
                        libglib2.0-dev libibverbs-dev liblzo2-dev

# build from source
git clone git://git.freedesktop.org/git/virglrenderer ${VIRGLRENDERER_PATH}
cd ${VIRGLRENDERER_PATH}
./autogen.sh
make
sudo make install

# update ld.conf
sudo /sbin/ldconfig 