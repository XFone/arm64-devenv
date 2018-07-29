# Development Notes of Raspberry Pi

<!-- markdownlint-disable MD004 MD007 MD012 -->

[RASPBIAN STRETCH LITE](https://downloads.raspberrypi.org/raspbian_lite_latest)

> _Minimal image based on Debian Stretch_

## References

### QEMU

- [Using QEMU to emulate a Raspberry Pi - 2017.8.27](https://blog.agchapman.com/using-qemu-to-emulate-a-raspberry-pi/)
    - [dhruvvyas90/qemu-rpi-kernel](https://github.com/dhruvvyas90/qemu-rpi-kernel) repository's kernels

```Bash
$ git clone https://github.com/dhruvvyas90/qemu-rpi-kernel.git
$ ls qemu-rpi-kernel
README.md                              kernel-qemu-4.4.26-jessie
kernel-qemu-3.10.25-wheezy             kernel-qemu-4.4.34-jessie
kernel-qemu-4.1.13-jessie              kernel-qemu-4.9.41-stretch
kernel-qemu-4.1.7-jessie               kernel-qemu-4.9.59-stretch
kernel-qemu-4.4.12-jessie              kernel-qemu-4.9.59-stretch_with_VirtFS
kernel-qemu-4.4.13-jessie              tools
kernel-qemu-4.4.21-jessie              versatile-pb.dtb
```

#### Old Information for Pi

1. [Raspberry Pi emulation on OS X](http://royvanrijn.com/blog/2014/06/raspberry-pi-emulation-on-os-x/)

2. [QEMU Raspberry Pi Emulation](https://qemu.weilnetz.de/test/system/arm/raspberry-pi/)

#### New Information for Pi 2

1. [How to emulate the Raspberry Pi 2 on QEMU?](https://stackoverflow.com/questions/28880833/how-to-emulate-the-raspberry-pi-2-on-qemu)

### Default Pi credentials

```Txt
Username: pi
Password: raspberry
```