# Android

<!-- markdownlint-disable MD004 MD007 MD010 MD012 -->

## Android SDK and NDK

- [Android Studio - Baidu Pan](http://pan.baidu.com/s/1sjK81Oh)
  - android-sdk_r24.1.2-linux.tgz
  - android-ndk-r10d-*.bin

- [Android Studio - Official Download](https://developer.android.google.cn/studio/#downloads)
  
- [NDK Stable r17b - Official Download](https://developer.android.google.cn/ndk/downloads/)
    - [android-ndk-r17b-linux-x86_64](https://dl.google.com/android/repository/android-ndk-r17b-linux-x86_64.zip)

## Android Kernel

### Download and Build Android kernel

1. (optional) setup a repo mirror

    ```Bash
    $ ../scripts/ubuntu16/setup_android-devel.sh
    # repo init -u https://android.googlesource.com/kernel/common -b master
    $ repo init -u git://mirrors.ustc.edu.cn/aosp/kernel/common --mirror
    $ repo sync
    $ git daemon --verbose --export-all --base-path=$(pwd)
    ```
    * repo command [helps](https://blog.csdn.net/sunweizhong1024/article/details/8987494)

2. check out from branch

    ```Bash
    # git clone https://android.googlesource.com/kernel/common.git kernel
    $ git clone https://github.com/aosp-mirror/kernel_common.git kernel
    $ cd kernel
    [~/kernel]$ git branch -a
    * master
      remotes/origin/HEAD -> origin/master
      remotes/origin/android-2.6.39
      ...
    [~/kernel]$ git checkout -b linux-2.6.39 origin/android-2.6.39
    ...
    [~/kernel]$ git checkout -b android-4.9 origin/android-4.9
    ...
    ```

3. building kernels - [manual](http://source.android.com/source/building-kernels.html)

### AOSP Resources

1. [Android Open Source Project - github](https://github.com/aosp-mirror)
    - Mirrored from https://android.googlesource.com/

2. [清华大学开源软件镜像站 - AOSP](https://mirrors.tuna.tsinghua.edu.cn/help/AOSP/)
    - repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest

3. [中科大LUG@USTC - AOSP](https://lug.ustc.edu.cn/wiki/mirrors/help/aosp)
    - repo init -u git://mirrors.ustc.edu.cn/aosp/platform/manifest
    - *不推荐使用 HTTP 协议同步，因为 HTTP 服务器不支持 repo sync 的 --depth 选项，可能导致部分仓库同步失败*

## Android LXC

```Bash
```

Useful references:

1. [Build lxc for android](https://gist.github.com/binkybear/18dab6ef15bfb8052f15c12c6b7777f3)

2. [ContainerArchitecture](https://wiki.ubuntu.com/Touch/ContainerArchitecture)
   - Booting the Android LXC container
   - Using a 64bit Android Container

## Run Android in QEMU

Building Android for x86_64 or arm64 in Qemu:

```Bash
# setup tools (android-6 use openjdk-1.7)
sudo /local-dev/scripts/ubuntu16/setup_aarch64-devel.sh
sudo /local-dev/scripts/ubuntu16/setup_android-devel.sh jdk7

# set environment PROJECT_PATH, ANDROID_PATH etc.
source /opt/src/devenv/env-android.sh
```

Build linux kernel (android-4.9)

```Bash
mkdir -p $LINUX_PATH ; cd $LINUX_PATH
git clone git://mirrors.ustc.edu.cn/aosp/kernel/common -b android-4.9 kernel
cd kernel
make ranchu64_defconfig
make -j4
```

* build error
  1. 'recipe for target 'net/ipv4/netfilter' failed.', solution:
      - make menuconfig
      - disable netfilter in 'networking support -> networking options'

  2. 'Could not mmap file: vmlinux', solution:
      - refer to [stackoverflow](https://stackoverflow.com/questions/23936929/error-could-not-mmap-file-vmlinux)
      - patch './scripts/link-vmlinux.sh' for build in VirtualBox shared folder

Build AOSP (branch **android-6.0.1_r81**):

```Bash
mkdir -p $ANDROID_PATH ; cd $ANDROID_PATH
repo init -u git://mirrors.ustc.edu.cn/aosp/platform/manifest -b android-6.0.1_r81

# cd .repo ; git clone https://github.com/robherring/android_manifest.git -b master local_manifests ; cd ..
repo sync -c

#cd device/linaro/generic ; make defconfig && make all ; cd ../../..

source build/envsetup.sh
#lunch linaro_arm64-userdebug
lunch aosp_arm64-eng
make -j4
```

* build error
  1. 'Please move your source tree to a case-sensitive filesystem.', solution (MacOS):
      - refer to [stackoverflow](https://stackoverflow.com/questions/8341375/move-android-source-into-case-sensitive-image)
      - option 1  "hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 40g ~/android.dmg"
      - option 2  create a "APFS (Case-sensitive)" sub-volume with 'Utilities → Disk Utility'

Make boot image and launch emulator:

```Bash
# Fetch the make boot image script 'mkbootimg'
git clone git://mirrors.ustc.edu.cn/aosp/platform/system/core $ANDROID_TOOLS_PATH

# launch android
/opt/src/images/launch-android.sh arm64
```

Other useful references:

1. [Building Android for Qemu: A Step-by-Step Guide](https://www.collabora.com/news-and-blog/blog/2016/09/02/building-android-for-qemu-a-step-by-step-guide/)
    + only for aosp version 6.x.x
    + **Virglrenderer** creates a virtual 3D GPU, that allows the Qemu guest to use the graphics capabilities of the host machine.

2. [How to Build and Run Android L 64-bit ARM in QEMU](https://www.cnx-software.com/2014/08/23/how-to-build-and-run-android-l-64-bit-arm-in-qemu/)

3. [预编译 Android 模拟器专用内核 2017-12-23](https://www.wolfcstech.com/2017/12/23/qemu_android_kernel/)
    + use "$AOSP/prebuilts/qemu-kernel/build-kernel.sh"

## Run Android in Real Machine - Hi3798cv200

[Development notes of Hi3798cv200](./images/dev-Hi3798/README.md)