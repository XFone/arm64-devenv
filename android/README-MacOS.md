# Building android AOSP on Mac OS X

<!-- markdownlint-disable MD004 MD007 MD010 MD012 -->

refert to this [article](http://tryge.com/2013/06/15/build-android-from-source-macosx/)

## Setting up the build environment

```Bash
brew install automake gpg git python
```

## Prepare a virtual disk to hold the android source

refer to [stackoverflow](https://stackoverflow.com/questions/8341375/move-android-source-into-case-sensitive-image)

- option 1  "hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 40g ~/android.dmg"
- option 2  create a "APFS (Case-sensitive)" sub-volume with 'Utilities → Disk Utility'

> mount point is '/Volumes/AndroidBuild'

## Downloading the source with repo

see [README](README.md)

```Bash
cd /Volumes/AndroidBuild
mkdir android
cd android

repo init -u git://mirrors.ustc.edu.cn/aosp/platform/manifest --depth 1 -b $ANDROID_VERSION
repo sync -c --no-tags --no-clone-bundle
```

## Building for a device

Before building, you need install XCode.

```Bash
cd /Volumes/AndroidBuild/android
. build/envsetup.sh

lunch aosp_x86_64-eng USE_CCACHE=1 CCACHE_DIR=ccache
make -j 8
```

* error:
    1. "Could not find a supported mac sdk: [10.10, 10.11. 10.12]":
        - in file 'build/core/combo/mac_version.mk' [解决macOSX10.12.SDK下编译出错的问题](http://palanceli.com/2016/09/25/2016/0925AOSPOnMac/)
            ```Makefile
            mac_sdk_versions_supported := 10.8 10.9 10.10 10.11 10.14(added)
            ```
        - or (in file 'build/soong/cc/config/x86_darwin_host.go'):
            ```Bash
            darwinSupportedSdkVersions = []string{
                    "10.10",
                    "10.11",
                    "10.12",
                    "10.13",    // <-- add this
            }
            ```
    2. 'prebuilts/misc/darwin-x86/bison/bison' broken (see #**patch-1**):
        ```Bash
        cd external/bison
        # See patch-1
        #git clone git://mirrors.ustc.edu.cn/aosp/platform/external/bison -b android-8.1.0_r1
        #git cherry-pick c0c852bd6fe462b148475476d9124fd740eba160
        mmm
        cd ..
        cp out/host/darwin-x86/bin/bison prebuilts/misc/darwin-x86/bison/
        ```
    3. compiling libcxx:
        - in file 'build/core/combo/HOST_darwin-x86_64.mk' and 'build/core/combo/HOST_darwin-x86.mk'
        ```make
        #HOST_GLOBAL_CPPFLAGS += -isystem $(mac_sdk_path)/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
        HOST_GLOBAL_CPPFLAGS += -I$(TOPDIR)external/libcxx/include
        ```
        - compiling libcxx
        ```bash
        cd external/libcxx
        mmm
        ```
    4. system/core/libcutils/threads.c:38:10: error: 'syscall' is deprecated

* [解决macOSX10.12.SDK下编译AOSP出错的问题](http://palanceli.com/2016/09/25/2016/0925AOSPOnMac/)

* patch-1:
    - 'external/bison/lib/vasnprintf.c:4871':
    ```C++
    # if !defined(__APPLE__) && !(((__GLIBC__ > 2 || (__GLIBC__ == 2 && __GLIBC_MINOR__ >= 3)) && !defined __UCLIBC__) || ((defined _WIN32 || defined __WIN32__) && ! defined __CYGWIN__))
    ```
  
## Using emulator in MacOS

Install Intel **HAXM** for CPU acceleration, from [here](https://github.com/intel/haxm/releases) and [docs](https://software.intel.com/en-us/articles/intel-hardware-accelerated-execution-manager-intel-haxm).


Run emulator:

```Bash
$ANDROID_SDK/emulator -avd <avd-name>
```
