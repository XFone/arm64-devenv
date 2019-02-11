# Android

<!-- markdownlint-disable MD004 MD007 MD010 MD012 MD032 MD033 MD036 -->

<meta charset="utf-8" />
<style>
blockquote {
    margin: 0;
    padding: 0;
}
code, pre {
    font-family: Consolas, Monaco, Andale Mono, Courier New, monospace;
}
code { /* small fonts */
    background-color: #f7f7f7;
    color: rgba(0, 0, 0, 0.75);
    border: 0;
    margin: 0;
    font-size: 9px;
}
pre {
    line-height: 0.8em;
    border-left: 1px solid #6CE26C;
}
pre > code {
    display: inline;
    max-width: initial;
    overflow: initial;
    line-height: inherit;
    white-space: pre;
    background: 0 0;
}
pre:not(.hljs), pre.hljs code > div {
    padding: 2px;
}
</style>

Table of Contents
- [Android](#android)
    - [Android SDK and NDK](#android-sdk-and-ndk)
        - [Compile with Android NDK](#compile-with-android-ndk)
        - [Run shell in android](#run-shell-in-android)
    - [Android Kernel](#android-kernel)
        - [Which Kernel Branch to Use](#which-kernel-branch-to-use)
        - [Download and Build Kernel](#download-and-build-kernel)
        - [AOSP Mirros and Resouces](#aosp-mirros-and-resouces)
    - [Run Android in QEMU](#run-android-in-qemu)
        - [Building Android for QEMU, x86_64 or arm64](#building-android-for-qemu-x8664-or-arm64)
        - [Manage Android Virtual Device (AVD)](#manage-android-virtual-device-avd)
        - [Run Android Emulator](#run-android-emulator)
        - [Run Android in QEMU manually (TODO)](#run-android-in-qemu-manually-todo)
        - [Other Useful References](#other-useful-references)
    - [Run Android in ARMv8](#run-android-in-armv8)
    - [Run Android in Real Machine - Hi3798cv200](#run-android-in-real-machine---hi3798cv200)

## Android SDK and NDK

- [Android Studio - Official Download](https://developer.android.google.cn/studio/#downloads)
    - Command line tools only: [sdk-tools-linux-4333796.zip](https://dl.google.com/android/repository/sdk-tools-darwin-4333796.zip)
    - Android SDK Docker Image - [docker: thyrlian/AndroidSDK](https://github.com/thyrlian/AndroidSDK)
        - SSH + VNC + NFS remote accessible

- [NDK Stable r17b - Official Download](https://developer.android.google.cn/ndk/downloads/)
    - android-ndk-linux: [android-ndk-r17b-linux-x86_64](https://dl.google.com/android/repository/android-ndk-r17b-linux-x86_64.zip)

Setting up ccache (optional):

```Bash
export USE_CCACHE=1
# By default the cache will be stored in ~/.ccache
export CCACHE_DIR=<path-to-your-cache-directory>
prebuilt/linux-x86/ccache/ccache -M 50G
```

### Compile with Android NDK

- [Android 使用NDK编译二进制文件并运行](https://blog.csdn.net/u014088294/article/details/49924967)

### Run shell in android

- [Run BASH script in Android](https://stackoverflow.com/questions/8094562/how-to-run-bash-script-in-my-android)
    ```Bash
    #!/system/bin/sh
    ```

## Android Kernel

### Which Kernel Branch to Use

Android version and kernel release:

|Android Version    |API Level  |Linux Kernel in AOSP|
|-------------------|-----------|--------------------|
|4.3   Jelly Bean   |18         |3.4.39   |
|4.4   Kit Kat      |19, 20     |3.10     |
|5.x   Lollipop     |21, 22     |3.16.1   |
|6.0   Marshmallow  |23         |3.18.10  |
|7.0   Nougat       |24         |4.4.1    |
|7.1   Nougat       |25         |4.4.1    |
|8.0   Oreo         |26         |4.9      |
|8.1   Oreo         |27         |4.10     |

Notes of kernel version:

1. qemu2 uses 'git://mirrors.ustc.edu.cn/aosp/kernel/goldfish -b android-goldfish-3.18'
2. arm64 uses 'git://mirrors.ustc.edu.cn/aosp/kernel/arm64 -b android-8.1.0_r0.79'
3. x86_64 has 'git://mirrors.ustc.edu.cn/aosp/kernel/x86_64 -b android-8.0.0_r0.6'

* See '[The Android Emulator and Upstream QEMU, by cdall@linaro.org 2017](https://blog.linuxplumbersconf.org/2017/ocw/system/presentations/4797/original/LPC17%20Android%20Emulator.pdf)' for detail:
    + Goldfish - virtual board based on qemu 1.10
    + **Ranchu** - virtual board based on qemu 2.8
    + AOSP kernel/goldfish.git - forked from kernel/common.git, and used to contain emulator-specific changes related to
goldfish and ranchu.
        - android-goldfish-3.10 (being deprecated)
            - emu_defconfig - qemu1
            - ranchu_defconfig - qemu2
        - android-goldfish-3.18 (current active branch)
            - ranchu/qemu2 only
            - Shipped with Android Oreo Release
        - android-4.4+ (future branches)
            - emulator kernel development happens in common.git
        - Current work: goldfish_pipe, **goldfish_dma** (60fps video)

* See [Android Platform release notes](https://developer.android.google.cn/studio/releases/platforms)
    + Android 9 (API level 28)   - Revision 1 (August 2018)
    + Android 8.1 (API level 27) - Revision 1 (December 2017)
    + Android 8.0 (API level 26) - Revision 2 (August 2017)
    + Android 7.1 (API level 25) - Revision 3 (December 2016) **arm64-v8a**
    + Android 7.0 (API level 24) - Revision 1 (August 2016)   **arm64-v8a**, **anbox** use this revision

### Download and Build Kernel

1. (optional) setup a repo mirror

    ```Bash
    $ ../scripts/ubuntu16/setup_android-devel.sh
    # repo init -u https://android.googlesource.com/platform/manifest -b master
    $ repo init -u git://mirrors.ustc.edu.cn/aosp/platform/manifest --mirror
    $ repo sync
    $ git daemon --verbose --export-all --base-path=$(pwd)
    ```
    * repo command [helps](https://blog.csdn.net/sunweizhong1024/article/details/8987494)

2. check out from branch

    ```Bash
    # git clone https://android.googlesource.com/kernel/common.git kernel
    $ git clone git://mirrors.ustc.edu.cn/aosp/kernel/common kernel
    $ cd kernel
    [~/kernel]$ git branch -a
    * master
      remotes/origin/HEAD -> origin/master
      remotes/origin/android-3.18
      ...
    [~/kernel]$ git checkout -b android-3.18 origin/android-3.18
    ...
    [~/kernel]$ git checkout -b android-4.9 origin/android-4.9
    ...
    ```

3. building kernels - [manual](http://source.android.com/source/building-kernels.html)

### AOSP Mirros and Resouces

1. [Android Open Source Project - github](https://github.com/aosp-mirror)
    - Mirrored from https://android.googlesource.com/

2. [清华大学开源软件镜像站 - AOSP](https://mirrors.tuna.tsinghua.edu.cn/help/AOSP/)
    - repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest

3. [中科大LUG@USTC - AOSP](https://lug.ustc.edu.cn/wiki/mirrors/help/aosp)
    - repo init -u git://mirrors.ustc.edu.cn/aosp/platform/manifest
    - *不推荐使用 HTTP 协议同步，因为 HTTP 服务器不支持 repo sync 的 --depth 选项，可能导致部分仓库同步失败*

## Run Android in QEMU

### Building Android for QEMU, x86_64 or arm64

Installing build toolchain (arm64)

```Bash
# check and install tools (android-8)
sudo /local-dev/scripts/ubuntu16/setup_aarch64-devel.sh
sudo /local-dev/scripts/ubuntu16/setup_android-devel.sh 8

# Fetch the make boot image script 'mkbootimg'
git clone git://mirrors.ustc.edu.cn/aosp/platform/system/core $ANDROID_TOOLS_PATH

# set environment PROJECT_PATH, ANDROID_PATH, and CROSS_COMPILE, etc.
# for android-ndk, you can also use ndk released in AOSP path ()
source /opt/src/devenv/env-android.sh arm64
```

Build linux kernel (**android-goldfish-3.18**, android-goldfish-4.9)

```Bash
mkdir -p $LINUX_PATH ; cd $LINUX_PATH
git clone git://mirrors.ustc.edu.cn/aosp/kernel/goldfish -b android-goldfish-3.18 kernel
cd kernel
# make x86_64_ranchu_defconfig
make ranchu_defconfig
make -j $(nproc)
```

* build error
  1. 'recipe for target 'net/ipv4/netfilter' failed.', solution:
      - option 1 local directory should be a **case-sensitive filesystem**, and re-checkout kernel source
      - option 2 make menuconfig, and disable netfilter in 'networking support -> networking options'

  2. 'Could not mmap file: vmlinux', solution:
      - refer to [stackoverflow](https://stackoverflow.com/questions/23936929/error-could-not-mmap-file-vmlinux)
      - patch './scripts/link-vmlinux.sh' - sortextable() for build in VirtualBox shared folder

* Useful references:
  1. [如何预编译 Android 模拟器专用内核](https://www.wolfcstech.com/2017/12/23/qemu_android_kernel/)
      - 原文 _$QEMU/android/docs/ANDROID-KERNEL.TXT_
      ```Bash
      $ANDROID_PATH/prebuilts/qemu-kernel/build-kernel.sh --arch=x86_64 --config=x86_64_ranchu
      ```

Build AOSP (branch android-6.0.1_r81, **android-8.1.0_r41**):

```Bash
mkdir -p $ANDROID_PATH ; cd $ANDROID_PATH
repo init -u git://mirrors.ustc.edu.cn/aosp/platform/manifest --depth 1 -b android-8.1.0_r41
repo sync -c --no-tags --no-clone-bundle

source build/envsetup.sh
#lunch aosp_x86_64-eng USE_CCACHE=1 CCACHE_DIR=ccache
lunch aosp_arm64-eng
make -j $(nproc)
```

* build error
  1. 'Please move your source tree to a **case-sensitive filesystem**.', solution (MacOS):
      - refer to [stackoverflow](https://stackoverflow.com/questions/8341375/move-android-source-into-case-sensitive-image)
      - option 1  "hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 40g ~/android.dmg"
      - option 2  create a "APFS (Case-sensitive)" sub-volume with 'Utilities → Disk Utility'
  2. 'Unable open oat file: Failed to map ELF file: mmap of file "out/target/product/generic_arm64/symbols/system/framework/arm64/boot.oat" failed':
      - the reason is same as 'Could not mmap file: vmlinux' in compiling kernel in VirtualBox shared folder
      - use local filesystem for this directory:
      ```Bash
      cd $ANDROID_PATH/out/target/product/generic_arm64/symbols/system/framework/
      mkdir -p ~/out/arm   ; ln -sf ~/out/arm .
      mkdir -p ~/out/arm64 ; ln -sf ~/out/arm64 .
      cd -
      ```

* output image files:
  1. ./out/target/product/generic_arm64/system.img
  2. ./out/target/product/generic_arm64/cache.img
  3. ./out/target/product/generic_arm64/userdata.img
  4. ./out/target/product/generic_arm64/ramdisk.img

* use [ccache](https://blog.csdn.net/zengrunxiu/article/details/80783590)

### Manage Android Virtual Device (AVD)

Creating Android Virtual Device (AVD) with [android tool](http://www.android-doc.com/tools/devices/index.html)

> The "android" command is deprecated.
> For manual SDK, AVD, and project management, please use **Android Studio**.
> For command-line tools, use **SDK tools** (**tools/bin/sdkmanager** and **tools/bin/avdmanager**)

Updating SDK and downloading required system images (**SDK tools**):

```Bash
export ANDROID_SDK_HOME=/Volumes/AndroidBuild
export ANDROID_SDK_ROOT=/Volumes/AndroidBuild/android-sdk
# get available package list
$ANDROID_SDK_ROOT/tools/bin/sdkmanager --list
# install emulator, platform-tools, platform
$ANDROID_SDK_ROOT/tools/bin/sdkmanager 'emulator'
$ANDROID_SDK_ROOT/tools/bin/sdkmanager 'platform-tools'
$ANDROID_SDK_ROOT/tools/bin/sdkmanager 'platforms;android-24'
# install system-images
$ANDROID_SDK_ROOT/tools/bin/sdkmanager 'system-images;android-24;google_apis;x86_64'
$ANDROID_SDK_ROOT/tools/bin/sdkmanager 'system-images;android-24;google_apis;arm64-v8a'
```

Then run avdmanager to create new AVD:

```Bash
touch $ANDROID_SDK_HOME/.android/repositories.cfg
# create avd with selected package, e.g., 'system-images;android-25;google_apis;x86_64'
$ANDROID_SDK_ROOT/tools/bin/avdmanager create avd -n 'tablet_x64' -d 34 -k 'system-images;android-24;google_apis;x86_64'
```

> **NOTE 1**: AVD directories are searched in the order $ANDROID_AVD_HOME, $ANDROID_SDK_HOME/avd and $HOME/.android/avd
> new avd device is saved in $ANDROID_SDK_HOME/avd directory

use following command to list available avd, devices and targets:

```Bash
$ANDROID_SDK_ROOT/tools/bin/avdmanager list [avd | device | target]
```

### Run Android Emulator

In Linux:

```Bash
$ANDROID_PATH/prebuilts/android-emulator/linux-x86_64/emulator -avd <avd-name> -qemu -m 512 -enable-kvm
```

In MacOS ([README-MacOS](./README-MacOS.md)):

```Bash
$ANDROID_PATH/prebuilts/android-emulator/darwin-x86_64/emulator -avd <avd-name>
```

**NOTE** more [emulator]((http://www.android-doc.com/tools/help/emulator.html)) document is [here](http://www.androiddocs.com/tools/devices/emulator.html).


### Run Android in QEMU manually (TODO)

Make boot image and launch emulator:

```Bash
# launch android
/opt/src/images/launch-android.sh arm64
```

### Other Useful References

1. [Building Android for Qemu: A Step-by-Step Guide](https://www.collabora.com/news-and-blog/blog/2016/09/02/building-android-for-qemu-a-step-by-step-guide/)
    + only for aosp version 6.x
    + uses '[Linaro Device Configs](https://github.com/robherring/android_manifest)'
    + **Virglrenderer** creates a virtual 3D GPU, that allows the Qemu guest to use the graphics capabilities of the host machine.

2. [How to Build and Run Android L 64-bit ARM in QEMU](https://www.cnx-software.com/2014/08/23/how-to-build-and-run-android-l-64-bit-arm-in-qemu/)
    + Linaro 13.11 Release with Linux Kernel 3.12 and Android 4.4
    + _How to Extract a Device Tree File from Android Firmware Files_

3. [预编译 Android 模拟器专用内核 2017-12-23](https://www.wolfcstech.com/2017/12/23/qemu_android_kernel/)
    + use "$AOSP/prebuilts/qemu-kernel/build-kernel.sh"

## Run Android in ARMv8

* [linaro armv8 project](https://www.linaro.org/initiatives/armv8/)
    + [downloads](https://www.linaro.org/latest/downloads/)
    + [Linaro Android Git Hosting](https://android-git.linaro.org/)
    ```Bash
    # according to 'Building Android for Qemu: A Step-by-Step Guide'
    cd .repo ; git clone https://github.com/robherring/android_manifest.git -b master local_manifests ; cd ..
    repo sync -c --no-tags --no-clone-bundle
    cd device/linaro/generic ; make defconfig && make all ; cd ../../..
    ```

## Run Android in Real Machine - Hi3798cv200

[Development notes of Hi3798cv200](./images/dev-Hi3798/README.md)
