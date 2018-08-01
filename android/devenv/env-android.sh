#!/usr/bin/env

# repo settings
export REPO_URL="https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/"
#export REPO_URL="https://gerrit-googlesource.proxy.ustclug.org/git-repo"
echo "REPO_URL    = \"$REPO_URL\""

# source path
ROOT_PATH=""
export PROJECT_PATH="${ROOT_PATH}/build"
export VIRGLRENDERER_PATH="${PROJECT_PATH}/virglrenderer"
export QEMU_PATH="${PROJECT_PATH}/qemu"
export LINUX_PATH="${PROJECT_PATH}/linux"
export ANDROID_PATH="${PROJECT_PATH}/android"
export ANDROID_TOOLS_PATH="${PROJECT_PATH}/android-tools"

# android-ndk (refer to 'kernel/build.config.goldfish.amr64')
export ANDROID_NDK="$PROJECT_PATH/android-ndk"
echo "ANDROID_NDK = \"$ANDROID_NDK\""

# cross compile kernel and app
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=aarch64-linux-android-
export PATH=$PATH:$ANDROID_NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/

# export BRANCH=android-4.4