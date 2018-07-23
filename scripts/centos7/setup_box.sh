#!/bin/bash

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

update_gpg_key()
{
  curl -s --remote-name --location https://yum.puppetlabs.com/RPM-GPG-KEY-puppet
  gpg --keyid-format 0xLONG --with-fingerprint ./RPM-GPG-KEY-puppet
  rpm --import RPM-GPG-KEY-puppet
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

if [ ! -n "$TZ" ]; then
  TZ=Asia/Shanghai
fi
mv /etc/localtime /etc/localtime.bak
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime

# Update GPG keys (for Puppet-Labs/puppet-agent)
# update_gpg_key

# Update fastest mirror
echo "Updating fastest mirror"
yum makecache fast

# Update system except Kernel (which needs also update VirtualBox Additions)
yum -y -x kernel* update

# Install common utilities
yum install -y net-tools

# Install others
# source ./setup_docker-ce.sh
# source ./setup_devtools.sh
