#!/bin/sh
# Requires upgrade_tool and libudev.so.1 (libudev1)
#

sudo upgrade_tool ul            ./tools/MiniLoaderAll.bin
sleep 1
sudo upgrade_tool di resource   ./lubuntu/resource.img
sudo upgrade_tool di kernel     ./lubuntu/kernel.img
#sudo upgrade_tool di rootfs     ./lubuntu/rootfs.img
sudo upgrade_tool RD

# Erase flash
# sudo upgrade_tool EF ./tools/MiniLoaderAll.bin
