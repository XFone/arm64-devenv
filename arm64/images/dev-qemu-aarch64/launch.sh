#!/bin/sh
#

MYPATH=$(dirname $(readlink -f $0))

# Customized settings
MEM=6144M
SMP=4
CPU=cortex-a57
MAC='52:54:00:09:a4:38'
SSH=20022
VNC=:2
QEMU=qemu-system-aarch64

# ISO and image disks
CDR_IMG=$MYPATH/debian-9.5.0-arm64-DVD-1.iso
HDA_IMG=./debian9-aa64.qcow2

# Qemu boot parameters
BOOT_IMG="-drive file=$MYPATH/QEMU_EFI.img,format=raw,if=pflash \
          -drive file=$MYPATH/EFI_DATA.img,format=raw,if=pflash \
         "

VGA_ARGS="-vga std"

CDR_ARGS=""

HDA_ARGS="-drive if=none,file=$HDA_IMG,id=hd0             \
          -device virtio-blk-device,drive=hd0             \
          "

NET_ARGS="-netdev user,id=eth0,hostfwd=tcp::$SSH-:22      \
          -device virtio-net-device,netdev=eth0,mac=$MAC  \
          "

SHARES=""

# usage: launch.sh [install|*]
if [ $# -eq 1 ]; then
  case $1 in
    install)
      if [ ! -f $HDA_IMG ]; then
        echo "Creating $HDA_IMG..."
        qemu-img create -f qcow2 $HDA_IMG 16G
      fi
      # BOOT_IMG="-bios $MYPATH/QEMU_EFI.fd"
      echo "Creating boot image $MYPATH/QEMU_EFI.img..."
      rm -f $MYPATH/QEMU_EFI.img $MYPATH/EFI_DATA.img
      dd if=/dev/zero bs=1M count=64 of=$MYPATH/QEMU_EFI.img
      dd if=/dev/zero bs=1M count=64 of=$MYPATH/EFI_DATA.img
      dd if=$MYPATH/QEMU_EFI.fd bs=1M of=$MYPATH/QEMU_EFI.img conv=notrunc
      # Attach ISO file to CDROM
      echo "Append CDROM $CDR_IMG..."
      CDR_ARGS="-drive file=$CDR_IMG,id=cdrom,if=none,media=cdrom       \
                -device virtio-scsi-device -device scsi-cd,drive=cdrom  \
                -boot d                                                 \
               "
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
$QEMU -m $MEM -cpu $CPU -smp $SMP -M virt     \
    $BOOT_IMG -localtime -monitor stdio       \
    $CDR_ARGS $HDA_ARGS $NET_ARGS             \
    $VGA_ARGS -vnc $VNC
