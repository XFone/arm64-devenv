#!/bin/sh
#
# Raspberry Pi (Versatile-PB board, 256MB of RAM)
#

MYPATH=$(dirname $(readlink -f $0))

# Customized settings
MEM=256M
SMP=1
CPU=arm1176
MCH=versatilepb
MAC='52:54:00:09:a4:58'
SSH=30022
VNC=:4
QEMU=qemu-system-arm

# SD image disks
CDR_IMG=$MYPATH/dev-RPi/2018-06-27-raspbian-stretch-lite.img
HDA_IMG=./raspbian-arm32.qcow2

# Qemu boot parameters
BOOT_IMG="-kernel $MYPATH/kernel-qemu-4.9.59-stretch            \
          -dtb $MYPATH/versatile-pb.dtb -no-reboot              \
         "

VGA_ARGS="-vga std"

CDR_ARGS=""

# HDS_ARGS="-sd win10iot.vhd"
HDA_ARGS="-hda $HDA_IMG"

#NET_ARGS="-net tap,ifname=vnet0,script=no,downscript=no"
NET_ARGS="-net nic -net user,hostfwd=tcp::$SSH-:22"

SHARES=""

APPEND="root=/dev/sda2 panic=1 rootfstype=ext4 rw"

# usage: launch.sh [install|*]
if [ $# -eq 1 ]; then
  case $1 in
    install)
      echo "Creating boot image $HDA_IMG..."
      # cp -a $CDR_IMG $HDA_IMG
      qemu-img convert -f raw -O qcow2 $CDR_IMG $HDA_IMG
      qemu-img resize $HDA_IMG +6G
      ;;
    *)
      VGA_ARGS="-vga virtio"
      ;;
  esac
fi

# NOT USED
OPT_ARGS="-serial telnet::1234,server -nographic -curses"
SPICE_ARGS="-spice gl=on,unix,addr=/tmp/spice.sock,disable-ticketing"

# Run qemu
echo "🌞  Starting QEMU with '$QEMU'..."
$QEMU -m $MEM -cpu $CPU -smp $SMP -M $MCH                 \
    $BOOT_IMG -append "$APPEND" -localtime -monitor stdio \
    $CDR_ARGS $HDA_ARGS $NET_ARGS                         \
    $VGA_ARGS -vnc $VNC

