#!/bin/bash
#

helpme()
{
  cat << USAGE
Usage: sudo $0

Installs the stuff needed to get the VirtualBox Linux into good shape to run 
our development environment.

1. This script needs to run as root.
2. The current directory must be the devenv project directory.

USAGE
}

# ---------------------------- Main ------------------------------
#
if [[ "$1" == "-?" || "$1" == "-h" || "$1" == "--help" ]] ; then
  helpme
  exit 1
fi

echo "🌞  Setup  VirtualBox linux environment..."

# Stop on first error
set -e

# Set timezone and localtime
if [ ! -n "$TZ" ]; then
  TZ=Asia/Shanghai
fi
mv /etc/localtime /etc/localtime.bak
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime

# Set language
cat >> /etc/environment <<END
LANG=en_US.UTF-8
LANGUAGE=en_US:en
LC_CTYPE=C
END
locale-gen en_US.UTF-8

# Update apt source (in China) : see https://www.linuxidc.com/Linux/2017-01/139458.htm
cp /etc/apt/sources.list /etc/apt/sources.list.backup
cat  > /etc/apt/sources.list <<END
# deb cdrom:[Ubuntu 16.04 LTS _Xenial Xerus_ - Release amd64 (20160420.1)]/ xenial main restricted
deb-src http://archive.ubuntu.com/ubuntu xenial main restricted #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse #Added by software-properties
deb http://archive.canonical.com/ubuntu xenial partner
deb-src http://archive.canonical.com/ubuntu xenial partner
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-security multiverse
END

# Update fastest cache
apt-get clean all && apt-get update
apt-get upgrade
apt-get install -y --allow-remove-essential apt-utils vim tzdata
