#!/bin/sh
#
# Raspberry Pi 2 (1GHz 4-cores Broadcom BCM2835 CPU, 1G of RAM)
#

MYPATH=$(dirname $(readlink -f $0))

# Customized settings
MEM=1G
SMP=4
CPU=arm1176
MCH=raspi2
MAC='52:54:00:09:a4:58'
SSH=30022
VNC=:4
QEMU=qemu-system-arm

# SD image disks
CDR_IMG=$MYPATH/dev-RPi/2018-06-27-raspbian-stretch-lite.img
HDA_IMG=./raspbian-arm32.qcow2

# Qemu boot parameters
BOOT_IMG="-kernel $MYPATH/kernel7.img                           \
          -dtb $MYPATH/bcm2709-rpi-2-b.dtb -no-reboot           \
         "

VGA_ARGS="-vga std"

CDR_ARGS=""

# HDS_ARGS="-sd win10iot.vhd"
HDA_ARGS="-hda $HDA_IMG"

#NET_ARGS="-net nic -net user,hostfwd=tcp::$SSH-:22"
NET_ARGS=""

SHARES=""

APPEND="root=/dev/mmcblk0p2 earlyprintk dwc_otg.lpm_enable=0 rw"

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

# Run qemu
echo "🌞  Starting QEMU with '$QEMU'..."
$QEMU -m $MEM -cpu $CPU -smp $SMP -M $MCH                 \
    $BOOT_IMG -append "$APPEND" -localtime -monitor stdio \
    $CDR_ARGS $HDA_ARGS $NET_ARGS                         \
    $VGA_ARGS -vnc $VNC

