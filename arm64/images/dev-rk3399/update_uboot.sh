#!/bin/sh
# Requires upgrade_tool and libudev.so.1 (libudev1)
#

sudo upgrade_tool ul            ./u-boot/rk3399_loader.bin
sleep 1
sudo upgrade_tool di uboot      ./u-boot/uboot.img
sudo upgrade_tool RD

# Erase flash
# sudo upgrade_tool EF ./lubuntu/MiniLoaderAll.bin
