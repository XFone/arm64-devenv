#!/bin/sh
# Requires upgrade_tool and libudev.so.1 (libudev1)
# 
 
sudo upgrade_tool ul           ./android/current/MiniLoaderAll.bin
sleep 1
sudo upgrade_tool di -p        ./android/current/parameter.txt
sudo upgrade_tool di uboot     ./android/current/uboot.img
sudo upgrade_tool di trust     ./android/current/trust.img
sudo upgrade_tool di misc      ./android/current/misc.img
sudo upgrade_tool di resource  ./android/current/resource.img
sudo upgrade_tool di kernel    ./android/current/kernel.img
sudo upgrade_tool di boot      ./android/current/boot.img
sudo upgrade_tool di recovery  ./android/current/recovery.img
sudo upgrade_tool di system    ./android/current/system.img
sudo upgrade_tool RD

# Erase flash
# sudo upgrade_tool EF MiniLoaderAll.bin
