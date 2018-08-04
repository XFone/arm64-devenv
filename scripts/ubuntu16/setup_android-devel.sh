#!/bin/bash
# Install android development environment
#

# install repo tool
sudo apt-get install -y python-pip 
mkdir -p ~/bin
curl https://raw.githubusercontent.com/aosp-mirror/tools_repo/master/repo > ~/bin/repo
chmod a+x ~/bin/repo

# replace the default REPO_URL with local mirror
REPO_URL_DEF="https://gerrit.googlesource.com/git-repo"
REPO_URL="https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/"
#REPO_URL="https://gerrit-googlesource.proxy.ustclug.org/git-repo"

# sed -i -e "s,${REPO_URL_DEF},${REPO_URL},g" ~/bin/repo

# packages for compiling kernel
sudo apt-get install -y bc libcap-dev libcap-ng-dev libjpeg8-dev liblzo2-dev \
    libncurses5-dev libnuma-dev

# packages for compiling AOSP
sudo apt-get install -y bison flex zip gperf g++-multilib gcc-multilib     \
    ccache  xsltproc zlib1g-dev libx11-dev libgl1-mesa-dev libc6-dev-i386  \
    lib32ncurses5-dev lib32z1-dev libxml2-utils

# android-<version> settings
case "$1" in
  6)
    # for android-6 install openjdk-7 (as ubuntu-16.4 uses openjdk-8 as default)
    sudo add-apt-repository ppa:openjdk-r/ppa
    sudo apt-get update
    sudo apt-get install -y openjdk-7-jdk
    # sudo update-alternatives --config java
    # sudo update-alternatives --config javac
    sudo update-java-alternatives --jre-headless --jre -s java-1.7.0-openjdk-amd64

    # fixing clang problem in ubuntu-16.04
    GLIBC_LD_PATH=prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.11-4.8/x86_64-linux/bin
    mv $GLIBC_LD_PATH/ld $GLIBC_LD_PATH/ld.orig
    cp /usr/bin/ld.gold $GLIBC_LD_PATH/ld
    ;;
  8)
    # TODO
    ;;
  *)
    ;;
esac

if [ -n "$1" ]; then
  if [ $1 == "6" ]; then


  fi
fi