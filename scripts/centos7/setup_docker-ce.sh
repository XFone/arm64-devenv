#!/bin/bash
# Install docker-ce (docker Comunity Edition) in CentOS 7+
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

# Select the fastest repository (docker, daocloud, or aliyun)
# REPO_URL=https://download.docker.com/linux/centos/docker-ce.repo
# REPO_URL=https://download.daocloud.io/docker/linux/centos/docker-ce.repo
REPO_URL=https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

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

# Install yum-utils and devicemapper storage driver.
yum install -y yum-utils device-mapper-persistent-data lvm2

# Set up the stable repository.
yum-config-manager --add-repo $REPO_URL
yum makecache fast

# Optional: enable the edge repository.
# yum-config-manager --enable docker-ce-edge

# Install the latest version of Docker (Comunity Edition)
yum install -y docker-ce

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
}
EOF
fi

# Configure docker (centos 7)
systemctl start docker

# Enable ip forwarding for docker
cat << EOF >> /etc/sysctl.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-arptables = 1
EOF

sysctl -p
