# AArch64

<!-- markdownlint-disable MD004 MD007 MD010 MD012 -->

> AArch64 - ARM V8架构

## Check Version

```Bash
etos@ETOS-FT1500A-V2:/etc/apt$ cat sources.list
# ETOS packages
deb http://xenloo:xenloo@120.55.169.94/etos-2.0 stretch main
```

```Bash
root@ETOS-FT1500A-V2:~# uname -a
Linux ETOS-FT1500A-V2 4.9.35-etos #4 SMP PREEMPT Mon Dec 4 10:29:56 UTC 2017 aarch64 GNU/Linux
```

* Version notes

```Bash
root@ETOS-FT1500A-V2:~# cat /etc/issue
ETOS FT1500A 2.0.0 \n \l

root@ETOS-FT1500A-V2:~# cat /etc/debian_version
9.1

root@ETOS-FT1500A-V2:~# cat /etc/os-release
ETTY_NAME="ETOS V2.0.0"
NAME="ETOS"
VERSION_ID="2.0.0"
VERSION="2.0.0"
ID=etos
HOME_URL="http://www.embedway.com/"
SUPPORT_URL="http://www.embedway.com/"
BUG_REPORT_URL="http://www.embedway.com/"
```

```Bash
root@ETOS-FT1500A-V2:~# apt-get install lsb-release
root@ETOS-FT1500A-V2:~# lsb_release -da
No LSB modules are available.
Distributor ID:	ETOS
Description:	ETOS GNU/Linux 9.1 (stretch)
Release:	9.1
Codename:	stretch

root@ETOS-FT1500A-V2:~# hostnamectl
   Static hostname: ETOS-FT1500A-V2
         Icon name: computer
        Machine ID: a2bafab1c9d344c5a565ffe11af2dfae
           Boot ID: 5c134c4ced514804ac1b8487cdd2dfc8
            Kernel: Linux 4.9.35-etos
      Architecture: arm64

```


## Install Qemu environment

### Linux

* 参考
- [在Linux下运行Qemu模拟AArch64硬件调试内核 - 2015.04](https://blog.csdn.net/jefbai/article/details/44901447)
- [用Qemu搭建aarch64学习环境](http://www.cnblogs.com/pengdonglin137/p/6431234.html)
- [X86_64平台上利用qemu安装aarch64架构的虚拟机 - 2018年01月03日](https://blog.csdn.net/chenxiangneu/article/details/78955462)
    - [Debian 9.5.0 arm64 ISO](https://mirrors.aliyun.com/debian-cd/9.5.0/arm64/iso-dvd/)
    - [QEFI Flash](http://releases.linaro.org/components/kernel/uefi-linaro/16.02/release/qemu64/QEMU_EFI.fd)

- [! ETOS packages](http://xenloo:xenloo@120.55.169.94/etos-2.0)


[Running Linux in QEMU’s aarch64 system emulation mode](https://www.bennee.com/~alex/blog/2014/05/09/running-linux-in-qemus-aarch64-system-emulation-mode/)
[Run Debian iso on QEMU ARMv8](https://kennedy-han.github.io/2015/06/16/QEMU-debian-ARMv8.html)

- [Not able to boot Debian arm64 on Windows using Qemu](https://superuser.com/questions/1035100/not-able-to-boot-debian-arm64-on-windows-using-qemu)
    + ...If you do want persistent boot configuration, grab the [other image](http://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.img.gz), decompress it, create another empty 64MB file (call it params.bin) and add -pflash QEMU_EFI.img -pflash params.bin to the command line (in that order).

- [KVM虚拟化技术之使用Qemu-kvm创建和管理虚拟机的方法](https://www.jb51.net/article/94086.htm)

- [How to run Ubuntu 16.04 Desktop on QEMU?](https://askubuntu.com/questions/884534/how-to-run-ubuntu-16-04-desktop-on-qemu/1046792#1046792)
    - -vga virtio
    - -soundhw hda

#### Shared folder - 9p-virtio

- [9p_virtio](https://www.linux-kvm.org/page/9p_virtio)

- [Share a Folder Between KVM Host and Guest 2012.8.11](https://dustymabe.com/2012/09/11/share-a-folder-between-kvm-host-and-guest/)

- [How to share a directory with the host without networking in QEMU?](https://superuser.com/questions/628169/how-to-share-a-directory-with-the-host-without-networking-in-qemu)

### Windows

- [Windows下，使用qemu安装Arm64 debian linux - 2017.10.21](https://blog.csdn.net/noword/article/details/78303973?locationNum=10&fps=1)

### Android

-[android/README](../android/README.md)

#### Android-Inject

[Android arm64中的so注入(inject) - 兼容x86 and arm](https://blog.csdn.net/liao0000/article/details/45482453)

### Cross Compilation

> [setup_aarch64-devel.sh](../scripts/debian9/setup_aarch64-devel.sh)

* 参考
- [aarch64(ARMv8)交叉编译环境下载](https://blog.csdn.net/x356982611/article/details/77333978)
    - [latest](https://releases.linaro.org/components/toolchain/binaries/latest/aarch64-linux-gnu/)
        - gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
