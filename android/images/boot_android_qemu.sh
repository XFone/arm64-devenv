#!/bin/bash

set -e

ARCH=${ARCH:="$1"}
ARCH=${ARCH:="x86_64"}

ANDROID_IMAGE_PATH=${ANDROID_PATH}/out/target/product/linaro_${ARCH}

QEMU_ARCH=$ARCH

PATH="${ANDROID_PATH}/out/host/linux-x86/bin/:$PATH"

case "$ARCH" in
arm)
    QEMU_OPTS="-cpu cortex-a15 -machine type=virt"
    KERNEL_CMDLINE='console=ttyAMA0,38400 earlycon=pl011,0x09000000 debug nosmp drm.debug=0x0 rootwait androidboot.selinux=permissive'
    KERNEL=${LINUX_PATH}/arch/arm/boot/zImage
    ;;
arm64)
    QEMU_ARCH="aarch64"
    QEMU_OPTS="-cpu cortex-a57 -machine type=virt"
    KERNEL_CMDLINE='console=ttyAMA0,38400 earlycon=pl011,0x09000000 nosmp drm.debug=0x0 rootwait rootdelay=5 androidboot.selinux=permissive'
    KERNEL=${LINUX_PATH}/arch/arm64/boot/Image
    ;;
x86_64)
    QEMU_ARCH="x86_64"
    KERNEL=${LINUX_PATH}/arch/x86_64/boot/bzImage
    QEMU_OPTS="-enable-kvm -smp 4"
    KERNEL_CMDLINE='console=tty0 console=ttyS0 debug drm.debug=0x0 androidboot.selinux=permissive'
    ;;
x86)
    QEMU_ARCH="x86"
    KERNEL=${LINUX_PATH}/arch/x86/boot/bzImage
    QEMU_OPTS="-enable-kvm -smp 4"
    KERNEL_CMDLINE='console=tty0 console=ttyS0 debug drm.debug=0x0 androidboot.selinux=permissive'
    ;;
esac

if [ ! -f ${PROJECT_PATH}/boot.img -o \
      ${LINUX_PATH}/arch/${ARCH}/boot/bzImage -nt ${PROJECT_PATH}/boot.img -o \
      ${ANDROID_IMAGE_PATH}/linaro_${ARCH}/ramdisk.img -nt ${PROJECT_PATH}/boot.img ]; then

    echo "Generating ${PROJECT_PATH}/boot.img ..."
    ${ANDROID_TOOLS_PATH}/mkbootimg/mkbootimg \
        --kernel ${LINUX_PATH}/arch/${ARCH}/boot/bzImage \
        --ramdisk ${ANDROID_IMAGE_PATH}/ramdisk.img \
        --output ${PROJECT_PATH}/boot.img \
        --pagesize 2048 \
        --base 0x80000000 \
        --cmdline 'rw console=ttyMSM0,115200n8'
fi

if [ ! -f ${PROJECT_PATH}/system_${ARCH}.raw -o ${ANDROID_IMAGE_PATH}/system.img -nt ${PROJECT_PATH}/system_${ARCH}.raw ]; then
    echo "Generating ${PROJECT_PATH}/system_${ARCH}.raw ..."
    simg2img ${ANDROID_IMAGE_PATH}/system.img ${PROJECT_PATH}/system_${ARCH}.raw
fi

if [ ! -f ${PROJECT_PATH}/cache_${ARCH}.raw -o ${ANDROID_IMAGE_PATH}/cache.img -nt ${PROJECT_PATH}/cache_${ARCH}.raw ]; then
    echo "Generating ${PROJECT_PATH}/cache_${ARCH}.raw ..."
    simg2img ${ANDROID_IMAGE_PATH}/cache.img ${PROJECT_PATH}/cache_${ARCH}.raw
fi

if [ ! -f ${PROJECT_PATH}/userdata_${ARCH}.raw -o ${ANDROID_IMAGE_PATH}/userdata.img -nt ${PROJECT_PATH}/userdata_${ARCH}.raw ]; then
    echo "Generating ${PROJECT_PATH}/userdata_${ARCH}.raw ..."
    simg2img ${ANDROID_IMAGE_PATH}/userdata.img ${PROJECT_PATH}/userdata_${ARCH}.raw
fi

${QEMU_PATH}/build/${QEMU_ARCH}-softmmu/qemu-system-${QEMU_ARCH} \
    ${QEMU_OPTS} \
    -append "${KERNEL_CMDLINE}" \
    -m 1024 \
    -serial mon:stdio \
    -kernel ${KERNEL} \
    -initrd ${ANDROID_IMAGE_PATH}/ramdisk.img \
    -drive index=0,if=none,id=system,file=${PROJECT_PATH}/system_${ARCH}.raw \
    -device virtio-blk-pci,drive=system \
    -drive index=1,if=none,id=cache,file=${PROJECT_PATH}/cache_${ARCH}.raw \
    -device virtio-blk-pci,drive=cache \
    -drive index=2,if=none,id=userdata,file=${PROJECT_PATH}/userdata_${ARCH}.raw \
    -device virtio-blk-pci,drive=userdata \
    -netdev user,id=mynet,hostfwd=tcp::5550-:5555 -device virtio-net-pci,netdev=mynet \
    -device virtio-gpu-pci,virgl -display gtk,gl=on \
    -usbdevice mouse \
    -usbdevice keyboard \
    -device nec-usb-xhci,id=xhci \
    -device sdhci-pci \
    -d guest_errors \
    -nodefaults \
    $*
#    -device virtio-mouse-pci -device virtio-keyboard-pci \

