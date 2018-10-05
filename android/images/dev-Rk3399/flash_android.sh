#!/bin/sh
# Requires upgrade_tool and libudev.so.1 (libudev1)
# 
 
sudo upgrade_tool ul           ./android/MiniLoaderAll.bin
sudo upgrade_tool di -p        ./android/parameter.txt
sudo upgrade_tool di uboot     ./android/uboot.img
sudo upgrade_tool di trust     ./android/trust.img
sudo upgrade_tool di misc      ./android/misc.img
sudo upgrade_tool di resource  ./android/resource.img
sudo upgrade_tool di kernel    ./android/kernel.img
sudo upgrade_tool di boot      ./android/boot.img
sudo upgrade_tool di recovery  ./android/recovery.img
sudo upgrade_tool di system    ./android/system.img
sudo upgrade_tool RD

# Erase flash
# sudo upgrade_tool EF MiniLoaderAll.bin
