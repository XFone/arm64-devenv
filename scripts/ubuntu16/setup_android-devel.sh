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

# tools for compiling kernel
sudo apt-get install -y libcap-dev libcap-ng-dev libjpeg8-dev liblzo2-dev \
    libncurses5-dev libnuma-dev bc

# install openjdk-7 (as ubuntu-16.4 uses openjdk-8 as default)
if [ -n "$1" ]; then
  if [ $1 == "jdk7" ]; then
    sudo add-apt-repository ppa:openjdk-r/ppa
    sudo apt-get update
    sudo apt-get install -y openjdk-7-jdk

    # sudo update-alternatives --config java
    # sudo update-alternatives --config javac
    sudo update-java-alternatives --jre-headless --jre -s java-1.7.0-openjdk-amd64
  fi
fi