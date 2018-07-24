# How to use this develepment environment

## 1. Rebuild VM box and run

* *Set fastest gem source in China

```Bash
gem sources -a https://gems.ruby-china.org/
# or
vagrant plugin install vagrant-hostsupdater --plugin-source http://rubygems.org/
```

* *Install required vagrant-vbguest plugin*

```Bash
vagrant plugin install vagrant-vbguest
```

* Run and do provision

```Bash
vagrant up
```

## 2. New an instance of qemu-system-aarch64 in VM box

* See [HOWTO](../images/HOWTO.md) for creating qemu image

## 3. Launch qemu in box and do testing 

* [GUEST] Launching qemu in box
```Bash
$ vagrant ssh
Last login: Tue Jul 24 12:54:09 2018 from 10.0.2.2
vagrant@aadev:~$ /opt/src/images/launch.sh
🌞  Starting QEMU with 'qemu-system-aarch64'...
QEMU 2.8.1 monitor - type 'help' for more information
```

* Connect to qemu instance from host:

  1. [HOST] Connect with vnc:2 (localhost:5902)

  2. [HOST] Connect with ssh ($ssh -p 20022 uzer@localhost)
