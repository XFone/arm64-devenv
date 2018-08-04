#!/bin/bash
# 
# Boot Android kernel in QEMU
# Usage: launch-android.sh [arch]
#      [arch]  - arm, arm64, x86, x86_64 (default)

set -e

# Customized settings
MEM=2048M
MAC='52:54:00:09:a4:78'
SSH=20022
VNC=:4

# $*
ARCH=${ARCH:="$1"}
ARCH=${ARCH:="x86_64"}

echo "Launching $ARCH..."

# ANDROID_IMAGE_PATH=${ANDROID_PATH}/out/target/product/linaro_${ARCH}
ANDROID_IMAGE_PATH=${ANDROID_PATH}/out/target/product/generic_${ARCH}

QEMU_ARCH=$ARCH

PATH="${ANDROID_PATH}/out/host/linux-x86/bin/:$PATH"

case "$ARCH" in
  arm)
    QEMU_OPTS="-cpu cortex-a15 -machine type=virt"
    KERNEL_CMDLINE='console=ttyAMA0,38400 earlycon=pl011,0x09000000 debug nosmp drm.debug=0x0 rootwait androidboot.selinux=permissive'
    KERNEL=${LINUX_PATH}/kernel/arch/arm/boot/zImage
    ;;
  arm64)
    QEMU_ARCH="aarch64"
    QEMU_OPTS="-cpu cortex-a57 -machine type=ranchu"
    KERNEL_CMDLINE='console=ttyAMA0,38400 earlycon=pl011,0x09000000 nosmp drm.debug=0x0 rootwait rootdelay=5 androidboot.selinux=permissive'
    KERNEL=${LINUX_PATH}/kernel/arch/arm64/boot/Image
    ;;
  x86_64)
    QEMU_ARCH="x86_64"
    #QEMU_OPTS="-enable-kvm -smp 4"
    QEMU_OPTS="-smp 2 -machine type=ubuntu"
    #KERNEL_CMDLINE="console=tty0 console=ttyS0 debug drm.debug=0x0 androidboot.selinux=permissive"
    #KERNEL_CMDLINE="console=tty0 console=ttyS0 debug drm.debug=0x0 androidboot.hardware=ranchu clocksource=pit android.qemud=1 android.checkjni=1 qemu=1 qemu.gles=1 qemu.encrypt=1 qemu.opengles.version=196608 cma=262M androidboot.android_dt_dir=/sys/bus/platform/devices/ANDR0001:00/properties/android/ ramoops.mem_address=0xff018000 ramoops.mem_size=0x10000 memmap=0x10000$0xff018000"
    KERNEL_CMDLINE="console=tty0 console=ttyS0 debug drm.debug=0x0 androidboot.hardware=ranchu clocksource=pit android.qemud=1 android.checkjni=1 qemu=1 qemu.gles=1 qemu.encrypt=1 qemu.opengles.version=196608 cma=262M androidboot.android_dt_dir=/sys/bus/platform/devices/ANDR0001:00/properties/android/"
    KERNEL=${LINUX_PATH}/kernel/arch/x86_64/boot/bzImage
    ;;
  x86)
    QEMU_ARCH="x86"
   #QEMU_OPTS="-enable-kvm -smp 4"
    QEMU_OPTS="-smp 2"
    KERNEL_CMDLINE="console=tty0 console=ttyS0 debug drm.debug=0x0 androidboot.selinux=permissive"
    KERNEL=${LINUX_PATH}/kernel/arch/x86/boot/bzImage
    ;;
  *)
    echo "Error: unsupported architecture"
    exit 0
    ;;
esac

if [ ! -f ${PROJECT_PATH}/boot_${ARCH}.img -o \
      ${LINUX_PATH}/kernel/arch/${ARCH}/boot/bzImage -nt ${PROJECT_PATH}/boot_${ARCH}.img -o \
      ${ANDROID_IMAGE_PATH}/ramdisk.img -nt ${PROJECT_PATH}/boot_${ARCH}.img ]; then

    echo "Generating ${PROJECT_PATH}/boot_${ARCH}.img ..."
    ${ANDROID_TOOLS_PATH}/mkbootimg/mkbootimg       \
        --kernel  ${KERNEL}                         \
        --ramdisk ${ANDROID_IMAGE_PATH}/ramdisk.img \
        --output  ${PROJECT_PATH}/boot_${ARCH}.img  \
        --pagesize 2048   \
        --base 0x80000000 \
        --cmdline "${KERNEL_CMDLINE}"
       #--cmdline 'rw console=ttyMSM0,115200n8'
fi

# Qemu parameters
# BOOT_ARGS="-drive file=${PROJECT_PATH}/boot_${ARCH}.img,format=raw -monitor stdio"
BOOT_ARGS="-kernel ${KERNEL} -initrd ${ANDROID_IMAGE_PATH}/ramdisk.img -serial mon:stdio"
# BOOT_ARGS="-kernel ${PROJECT_PATH}/kernel-qemu2 -initrd ${ANDROID_IMAGE_PATH}/ramdisk.img -serial mon:stdio"

BIOS_ARGS="-L ${ANDROID_PATH}/prebuilts/android-emulator/linux-x86_64/lib/pc-bios"

VGA_ARGS="-vga std -vnc $VNC"

NET_ARGS="-netdev user,id=eth0,hostfwd=tcp::5550-:5555      \
          -device virtio-net-pci,netdev=eth0,mac=$MAC       \
          "

# GPU_ARGS="-device virtio-gpu-pci,virgl -display gtk,gl=on"
GPU_ARGS=""


# NOT USED
HMI_ARGS="-device virtio-mouse-pci -device virtio-keyboard-pci"
OPT_ARGS="-serial telnet::1234,server -nographic -curses"
SPICE_ARGS="-spice gl=on,unix,addr=/tmp/spice.sock,disable-ticketing"
USB_ARGS="-usbdevice mouse -usbdevice keyboard"

# ${ANDROID_PATH}/prebuilts/android-emulator/linux-x86_64/emulator
qemu-system-${QEMU_ARCH}                \
    ${QEMU_OPTS} -m ${MEM}  -nodefaults \
    ${BOOT_ARGS} -localtime -no-reboot  \
    ${BIOS_ARGS} -append "${KERNEL_CMDLINE}" \
    -drive index=0,if=none,id=system,format=raw,file=${ANDROID_IMAGE_PATH}/system.img     \
    -device virtio-blk-pci,drive=system                                                   \
    -drive index=1,if=none,id=cache,format=raw,file=${ANDROID_IMAGE_PATH}/cache.img       \
    -device virtio-blk-pci,drive=cache                                                    \
    -drive index=2,if=none,id=userdata,format=raw,file=${ANDROID_IMAGE_PATH}/userdata.img \
    -device virtio-blk-pci,drive=userdata                                                 \
    ${NET_ARGS} ${GPU_ARGS} ${VGA_ARGS} \
    -device nec-usb-xhci,id=xhci \
    -device sdhci-pci \
    -d guest_errors



# emulator-x86_64 default log
# qemu-system-x86_64 -dns-server 192.168.31.1 -serial null -device goldfish_pstore,addr=0xff018000,size=0x10000,file=$ANDROID_IMAGE_PATH/data/misc/pstore/pstore.bin -cpu android64 -enable-hax -smp cores=2 -m 2048 -lcd-density 240 -nodefaults -kernel $ANDROID_IMAGE_PATH/kernel-ranchu -initrd $ANDROID_IMAGE_PATH/ramdisk.img -drive if=none,index=0,id=system,file=$ANDROID_IMAGE_PATH/system-qemu.img,read-only -device virtio-blk-pci,drive=system,modern-pio-notify -drive if=none,index=1,id=cache,file=$ANDROID_IMAGE_PATH/cache.img.qcow2,overlap-check=none,cache=unsafe,l2-cache-size=1048576 -device virtio-blk-pci,drive=cache,modern-pio-notify -drive if=none,index=2,id=userdata,file=$ANDROID_IMAGE_PATH/userdata-qemu.img.qcow2,overlap-check=none,cache=unsafe,l2-cache-size=1048576 -device virtio-blk-pci,drive=userdata,modern-pio-notify -drive if=none,index=3,id=encrypt,file=$ANDROID_IMAGE_PATH/encryptionkey.img.qcow2,overlap-check=none,cache=unsafe,l2-cache-size=1048576 -device virtio-blk-pci,drive=encrypt,modern-pio-notify -drive if=none,index=4,id=vendor,file=$ANDROID_IMAGE_PATH/vendor-qemu.img,read-only -device virtio-blk-pci,drive=vendor,modern-pio-notify -netdev user,id=mynet -device virtio-net-pci,netdev=mynet -show-cursor -L $ANDROID_PATH/prebuilts/android-emulator/darwin-x86_64/lib/pc-bios -soundhw hda -vga none -append 'qemu=1 androidboot.hardware=ranchu clocksource=pit android.qemud=1 console=0 android.checkjni=1 qemu.gles=1 qemu.encrypt=1 qemu.opengles.version=196608 cma=262M androidboot.android_dt_dir=/sys/bus/platform/devices/ANDR0001:00/properties/android/ ramoops.mem_address=0xff018000 ramoops.mem_size=0x10000 memmap=0x10000$0xff018000' -android-hw $ANDROID_IMAGE_PATH/hardware-qemu.ini