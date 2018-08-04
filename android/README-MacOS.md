# Building android AOSP on Mac OS X

<!-- markdownlint-disable MD004 MD007 MD010 MD012 -->

refert to this [article](http://tryge.com/2013/06/15/build-android-from-source-macosx/)

## Setting up the build environment

```Bash
brew install automake gpg git python
# following is no need for XCode 9.4.1+
# brew tap homebrew/dupes
# brew install apple-gcc42
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
    1. "Could not find a supported mac sdk: [ 10.10, 10.11. 10.12]":
        - in file 'build/soong/cc/config/x86_darwin_host.go':
        ```Bash
        darwinSupportedSdkVersions = []string{
                "10.10",
                "10.11",
                "10.12",
                "10.13",    // <-- add this
        }
        ```
    2. 'prebuilts/misc/darwin-x86/bison/bison' broken:
        ```Bash
        cd external/bison
        # See patch-1
        #git clone git://mirrors.ustc.edu.cn/aosp/platform/external/bison -b android-8.1.0_r1
        #git cherry-pick c0c852bd6fe462b148475476d9124fd740eba160
        mm
        cd ..
        cp out/host/darwin-x86/bin/bison prebuilts/misc/darwin-x86/bison/
        ```
    3. nothing

* patch-1:
    - 'external/bison/lib/vasnprintf.c:4871':
    ```C++
    # if !defined(__APPLE__) && !(((__GLIBC__ > 2 || (__GLIBC__ == 2 && __GLIBC_MINOR__ >= 3)) && !defined __UCLIBC__) || ((defined _WIN32 || defined __WIN32__) && ! defined __CYGWIN__))
    ```
  
## Using emulator in MacOS

Install Intel **HAXM** for CPU acceleration, from [here](https://github.com/intel/haxm/releases) and [docs](https://software.intel.com/en-us/articles/intel-hardware-accelerated-execution-manager-intel-haxm).

Creating Android Virtual Device (AVD) with [android tool](http://www.android-doc.com/tools/devices/index.html)

```Bash
cd $ANDROID_PATH
ANDROID_SWT=./prebuilts/tools/darwin-x86_64/swt ./prebuilts/devtools/tools/android
```

After updating SDK and downloading required images, just run to create new ACD:

```Bash
./prebuilts/devtools/tools/android avd
```

> new avd device is saved in host ~/.android/ directory

use following command to list available avd, devices and targets:

```Bash
./prebuilts/devtools/tools/android list [avd | device | target]
```

Run emulator:

```Bash
./prebuilts/android-emulator/darwin-x86_64/emulator -avd <avd-name>
```

- more emulator [document](http://www.android-doc.com/tools/help/emulator.html)