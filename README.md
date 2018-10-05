# Development Environment and Tools for ARM64 (aarch64), Android and Container

<!-- markdownlint-disable MD004 MD007 MD012 MD036 -->

## Android

- See [android devel](./android/README.md)

### Android in Virtual Machine

1. [How to Run Android Apps in Linux with AndroVM](https://www.cnx-software.com/2013/03/01/how-to-run-android-apps-in-linux-with-androvm/)
    - [androvm.org](http://androvm.org) now is [GenyMotion](https://www.genymotion.com/)

2. [GenyMobile](https://www.genymobile.com/) owns [GenyMotion - Android as a Service](https://www.genymotion.com/)
    > _Cloud-based Android virtual devices to boost your test automation or run your app in your website_
    1. PaaS (Virtual images on your cloud provider) - $0.5/hour per VD (+cloud providers fees)
    2. SaaS (Android virtual devices available on SaaS) - Pricing starts at 200$/month

3. [Shashlik](http://www.shashlik.io/)
    > _ANDROID APPLICATIONS ON REAL LINUX_
    - [github](https://github.com/shashlik)

### Android in Linux Container

- See [android in lxc](./android/lxc/README.md)

### Android Emulator in Docker

- See [android in docker](./android/docker/README.md)

## ARM32 and ARM32

- ARM Architectures
    - eabi: embedded applicaion binary interface
    - armel: arm eabi little endian, softfp
    - armhf: arm hard float
    - arm64: hard float
  
- [How to run armhf executables on an arm64 system](https://askubuntu.com/questions/928249/how-to-run-armhf-executables-on-an-arm64-system)
    + Arm32 support is optional on arm64. In practice, there is only one arm64 CPU that omits legacy arm32 instruction set support - _Cavium ThunderX_.