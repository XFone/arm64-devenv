# How to use this develepment environment

## 1. Rebuild image and run

* *Fast gem source in China

```Bash
gem sources -a https://gems.ruby-china.org/
# or
vagrant plugin install vagrant-hostsupdater --plugin-source http://rubygems.org/
```

* *required vagrant-vbguest plugin*

```Bash
vagrant plugin install vagrant-vbguest
```

* run and do provision

```Bash
vagrant up
```

## 2. Setup Android Development Environmnet

```Bash
vagrant ssh
```

* Next step: see [Download and Build Android kernel](../README.md#Android%20Kernel)

## 3. Usbserial in ubuntu16

```Bash
sudo apt-get install linux-image-extra-virtual
```
