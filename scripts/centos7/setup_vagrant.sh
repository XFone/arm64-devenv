#!/bin/bash
#

# 1. Install Vagrant on CentOS/Redhat
# VERSION=1.9.8
VERSION=2.0.0

# yum install -y https://releases.hashicorp.com/vagrant/${VERSION}/vagrant_${VERSION}_x86_64.rpm
sudo yum install -y vagrant_${VERSION}_x86_64.rpm

# 2. Install vagrant-libvirt plugin
sudo yum install -y qemu libvirt libvirt-devel ruby-devel gcc qemu-kvm
vagrant plugin install vagrant-libvirt

# 3. Install vagrant plugins
vagrant plugin install vagrant-vbguest vagrant-triggers

# 4. Enable nfs-server for folder sync
sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl start rpcbind
sudo systemctl start nfs-server
#sudo systemctl start rpc-statd
#sudo systemctl start nfs-idmapd

sudo firewall-cmd --permanent --zone public --add-service mountd
sudo firewall-cmd --permanent --zone public --add-service rpc-bind
sudo firewall-cmd --permanent --zone public --add-service nfs
sudo firewall-cmd --permanent --zone public --add-port 2049/udp
sudo firewall-cmd --reload

# 5. Run vagrant as a normal user
sudo gpasswd -a ${USER} libvirt
newgrp libvirt

sudo getent group vagrant >/dev/null || sudo groupadd -r vagrant
sudo gpasswd -a ${USER} vagrant
newgrp vagrant
