#!/bin/bash
# Install aarch64 devel environment and qemu testbed
#

# 1. Install development tools
sudo apt-get install -y git gcc g++ automake autoconf libtool make
sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

# 2. Install qemu system for aarch64, arm
sudo apt-get install -y qemu-system-arm qemu-efi 

# sudo apt-get install -y xorg-dev xserver-xorg-video-qxl
