#!/bin/bash
# Install docker-ce (docker Comunity Edition) in Debian 9
# refer to https://docs.docker.com/engine/installation/linux/centos/
#
# The difference of docker-ce and docker-ee, see 
#   http://itmuch.com/docker/docker-1/ , or 
#   https://blog.docker.com/2017/03/docker-enterprise-edition/ 
#
# Usage: ./setup_docker-ce.sh [<insecure-registry>] [<disk-device>]
#   insecure-registry   docker insecure registry (default is 127.0.0.1:5000)
#   disk-device         disk to setup device mapper (/dev/sdb)
#

# Select the fastest repository (docker, or aliyun)
# REPO_URL=https://download.docker.com/linux/debian
REPO_URL=https://mirrors.aliyun.com/docker-ce/linux/debian

# replace aarch64 with arm64
ARCH=$(uname -m)
if [ $ARCH == "aarch64" ]; then
  ARCH="arm64"
fi

# Registry URLs
INSECURE_URL=127.0.0.1:5000
if [ -n "$1" ]; then
  INSECURE_URL=$1
  echo "set insecure-registry to '$INSECURE_URL'"
fi

DISK_DEVICE=
if [ -n "$2" ]; then
  DISK_DEVICE=$2
  echo "set disk-device to '$DISK_DEVICE'"
fi

# ----------------------------- Start setup ----------------------------------

echo "🌞  Setup docker Comunity Edition (stable) ..."

# Install devicemapper storage driver.
apt-get remove -y docker.io
apt-get remove -y docker docker-engine
apt-get install -y lvm2 apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Set up the stable repository.
# add-apt-repository "deb [arch=$ARCH] $REPO_URL $(lsb_release -cs) stable"
echo "deb [arch=$ARCH] $REPO_URL $(lsb_release -cs) stable" | \
    tee /etc/apt/sources.list.d/docker.list

# Install GPG key
# apt-get install -y debian-keyring debian-archive-keyring
# apt-key adv --keyserver keyserver.docker.com --recv-keys 7EA0A9C3F273FCD8
curl -fsSL $REPO_URL/gpg | apt-key add -

apt-key fingerprint 0EBFCD88
apt-get update
# apt-cache policy docker-ce

# Install the latest version of Docker (Comunity Edition)
apt-get install -y docker-ce

# Docker: setup private insecure registry and devivemapper in direct-lvm mode
#
#  **devicemapper** storage driver is the only supported storage driver for 
#  Docker EE and Commercially Supported Docker Engine (CS-Engine) on RHEL, 
#  CentOS, and Oracle Linux. 
#  https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/
#
mkdir -p /etc/docker
if [ -n "$DISK_DEVICE" ]; then
  echo "devicemapper: usage of direct-lvm devices"
  cat << EOF > /etc/docker/daemon.json
{
  "insecure-registries": ["$INSECURE_URL"],
  "registry-mirrors": ["https://registry.docker-cn.com"]
  "storage-driver": "devicemapper",
  "storage-opts": [
    "dm.thinpooldev=/dev/mapper/docker-thinpool",
    "dm.use_deferred_removal=true",
    "dm.use_deferred_deletion=true",
    "dm.min_free_space=10%"
  ]
}
EOF
  pvcreate $DISK_DEVICE
  vgcreate docker $DISK_DEVICE
  lvcreate --wipesignatures y -n thinpool docker -l 95%VG
  lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG
  lvconvert -y --zero n -c 512K --thinpool docker/thinpool \
    --poolmetadata docker/thinpoolmeta
  cat << EOF > /etc/lvm/profile/docker-thinpool.profile
activation {
  thin_pool_autoextend_threshold=80
  thin_pool_autoextend_percent=20
}
EOF
  lvchange --metadataprofile docker-thinpool docker/thinpool
  lvs -o+seg_monitor
  # print logic volumns
  #lvscan
  
else
  echo "WARNING: devicemapper: usage of loopback devices"
  cat << EOF > /etc/docker/daemon.json
{
  "insecure-registries": ["$INSECURE_URL"]
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
EOF
fi

# Configure docker (debian9)
systemctl start docker

# Enable ip forwarding for docker
cat << EOF >> /etc/sysctl.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-arptables = 1
EOF

sysctl -p
