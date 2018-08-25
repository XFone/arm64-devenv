# Android (Emulator) in Docker

<!-- markdownlint-disable MD004 MD007 MD012 MD029 MD033 -->

## Android Emulator in Docker

1. [Android Emulator on Docker Container](https://medium.com/@AndreSand/android-emulator-on-docker-container-f20c49b129ef)
    - [source](https://github.com/thyrlian/AndroidSDK)
    - **thyrlian/android-sdk-vnc**

2. [Building a Docker Image with an Android Emulator on AWS](http://typemismatch.com/building-a-docker-image-with-an-android-emulator-on-aws/)

3. [How to run the Android Emulator on Amazon EC2 and Google Cloud](https://www.tuicool.com/articles/BFfmUj)

### Guide - The Android Emulator and Upstream QEMU

- See '[The Android Emulator and Upstream QEMU, by cdall@linaro.org 2017](https://blog.linuxplumbersconf.org/2017/ocw/system/presentations/4797/original/LPC17%20Android%20Emulator.pdf)'
    - android-4.4+ (future branches)
        - emulator kernel development happens in common.git
    - Current work: goldfish_pipe, **goldfish_dma** (60fps video)

## Display and Remote Access

### Sprice

- [桌面虚拟化传输协议之android spice](https://blog.csdn.net/benpaobagzb/article/details/50803388)
    * [Compile Android Spice(aSpice)](https://blog.lofyer.org/ndk-compile-android-spiceaspice/)

### X11

1. [在 X11 中实现 GTK+ 3 的 OpenGL 支持](https://blog.csdn.net/drcwr/article/details/41978931)
    * 2014/12/17
    * 从 GLX 和 X11 谈起
        * 从 GTK+ 3.0 开始，它将所有的二维图形绘制的任务（也就是 GDK 的任务）都交给了 Cairo 库，而 Cairo 库则是 X11、Wayland、Mac OS X 及 MS Windows 等主流窗口系统的二维图形渲染功能的抽象层
        * 通过 GLX 支持 OpenGL

### VNC and noVNC

1. [How to use Android emulator via VNC](https://stackoverflow.com/questions/12992289/how-to-use-android-emulator-via-vnc)

2. [Android VNC](https://github.com/binkybear/androidVNC)

3. [基于 VNCServer + noVNC 构建 Docker 桌面系统](https://blog.csdn.net/tinylab/article/details/45678923)
    * _noVNC 被普遍用在各大云计算、虚拟机控制面板中，比如 OpenStack Dashboard 和 OpenNebula Sunstone 都用的是 noVNC。noVNC 采用 WebSockets 实现，但是当前蛮多 VNC 服务器都不支持 WebSockets，所以 noVNC 不能直连 VNC 服务器，而是需要开启一个代理来做 WebSockets 和 TCP sockets 之间的转换。这个代理叫做 websockify_
    * !! [Running GUI apps with Docker for remote Access](https://vocon-it.com/2016/04/28/running-gui-apps-with-docker-for-remote-access/)
        * aixhin/vnc  | **consol/ubuntu-xfce-vnc**
        * wget http://ipinfo.io/ip -qO - 52.28.184.18
    * [ref](https://stackoverflow.com/questions/16296753/can-you-run-gui-applications-in-a-docker-container)
        * another way : '-v /tmp/.X11-unix:/tmp/.X11-unix' - using X on the host


### VPN

1. [Kali VPN of DOOM (OpenVPN server)](https://github.com/binkybear/rock3tman)
