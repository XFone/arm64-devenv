#!/usr/bin/env
#
# usage: source env-android.sh [arm|arm64|x86|x86_64]
#

# repo settings
REPO_URL="https://mirrors.tuna.tsinghua.edu.cn/git/git-repo"
#REPO_URL="https://gerrit-googlesource.proxy.ustclug.org/git-repo"
echo "REPO_URL    = \"$REPO_URL\""

export REPO_URL

# source path
ROOT_PATH=""
export PROJECT_PATH="${ROOT_PATH}/build"
export VIRGLRENDERER_PATH="${PROJECT_PATH}/virglrenderer"
export QEMU_PATH="${PROJECT_PATH}/qemu"
export LINUX_PATH="${PROJECT_PATH}/linux"
export ANDROID_PATH="${PROJECT_PATH}/android"
export ANDROID_TOOLS_PATH="${PROJECT_PATH}/android-tools"

# android-ndk (refer to 'kernel/build.config.goldfish.arm64')
ANDROID_NDK="$PROJECT_PATH/android-ndk"
echo "ANDROID_NDK = $(readlink -f $ANDROID_NDK)"

# gcc version of android-ndk
GCC_VER=4.9

# cross compile kernel and app
ARCH=$1
ARCH=${ARCH:="x86_64"}

echo "ARCH        = $ARCH"

case "$ARCH" in
  arm)
    SUBARCH=arm
    CROSS_COMPILE=arm-linux-androideabi-
   #TOOLCHAIN_PATH=$ANDROID_PATH/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-${GCC_VER}/bin
    TOOLCHAIN_PATH=$ANDROID_NDK/toolchains/arm-linux-androideabi-${GCC_VER}/prebuilt/linux-x86_64/bin
    ;;
  arm64 | aarch64)
    SUBARCH=arm64
    CROSS_COMPILE=aarch64-linux-android-
   #TOOLCHAIN_PATH=$ANDROID_PATH/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-${GCC_VER}/bin
    TOOLCHAIN_PATH=$ANDROID_NDK/toolchains/aarch64-linux-android-${GCC_VER}/prebuilt/linux-x86_64/bin
    ;;
  x86_64)
    SUBARCH=x86
    CROSS_COMPILE=x86_64-linux-android-
   #TOOLCHAIN_PATH=$ANDROID_PATH/prebuilts/gcc/linux-x86/x86/x86_64-linux-android-${GCC_VER}/bin
    TOOLCHAIN_PATH=$ANDROID_NDK/toolchains/x86_64-${GCC_VER}/prebuilt/linux-x86_64/bin
    ;;
  x86)
    SUBARCH=x86
    CROSS_COMPILE=i686-linux-android-
    TOOLCHAIN_PATH=$ANDROID_NDK/toolchains/x86-${GCC_VER}/prebuilt/linux-x86_64/bin
    ;;
esac

export ANDROID_NDK
export ARCH SUBARCH CROSS_COMPILE
export PATH=$PATH:$TOOLCHAIN_PATH
# export BRANCH=android-4.4

# Load NDK environment
# cd $ANDROID_PATH
# . build/envsetup.sh 