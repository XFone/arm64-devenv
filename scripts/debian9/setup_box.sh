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
cat > /etc/environment <<END
LANG=en_US.UTF-8
LANGUAGE=en_US:en
LC_CTYPE=C
END
locale-gen

# Update apt source (in China) : see https://yq.aliyun.com/articles/533974
cp /etc/apt/sources.list /etc/apt/sources.list.backup
cat  > /etc/apt/sources.list <<END
deb http://mirrors.163.com/debian/ stretch main
deb http://mirrors.163.com/debian/ stretch-updates main non-free contrib
deb-src http://mirrors.163.com/debian/ stretch-updates main non-free contrib
deb http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib
deb http://httpredir.debian.org/debian stretch-backports main contrib non-free
END

# Update fastest cache
apt-get clean all && apt-get update
apt-get upgrade
apt-get install -y --allow-remove-essential apt-utils vim tzdata
