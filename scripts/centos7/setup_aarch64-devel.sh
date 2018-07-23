#!/bin/bash
#

# 0. Install epel
# sudo yum localinstall --nogpgcheck http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
sudo yum -y install epel-release
# yum --enablerepo=extras install epel-release

# 1. Install aarch64, arm
sudo yum install -y qemu-system-arm

# qemu-system-aarch64 -machine virt -cpu cortex-a57 -machine type=virt -nographic -smp 1 -m 2048 -kernel aarch64-linux-3.15rc2-buildroot.img  --append "console=ttyAMA0"

# qemu-system-aarch64 -machine virt -cpu cortex-a57 -machine type=virt -nographic -smp 1 -m 2048 -kernel /home/jefby/linux-3.19.3/arch/arm64/boot/Image  --append "console=ttyAMA0"
