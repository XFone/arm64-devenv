#!/bin/bash
#
# Run vagrant as a normal user

# add user to group 'libvirt'
sudo gpasswd -a ${USER} libvirt
newgrp libvirt

# add user to group 'vagrant'
sudo getent group vagrant >/dev/null || sudo groupadd -r vagrant
sudo gpasswd -a ${USER} vagrant
newgrp vagrant
