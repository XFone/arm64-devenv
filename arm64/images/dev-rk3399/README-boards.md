# Hardware Notes for RK3399

<!-- markdownlint-disable MD004 MD007 MD012 -->

[Rockchip RK3399 SoC](http://opensource.rock-chips.com/wiki_RK3399)

## Board 1: NanoPC-T4 (RK3399)

- [Wiki](http://wiki.friendlyarm.com/wiki/index.php/NanoPC-T4/zh)
    - [Schematic](http://wiki.friendlyarm.com/wiki/images/f/f4/NanoPC-T4-1802-Schematic.pdf)
    - [Drawing (.dxf)](http://wiki.friendlyarm.com/wiki/images/b/bc/NanoPC-T4_1802_Drawing%28dxf%29.zip)
    - 4K Video: Qt5-VideoPlayer / Gstreamer 1.0
    - USB Camera: xawtv
    - OpenCV 3.4
    - Qt5 WebGL | Qt5 VNC
        - KMS   : Linux kernel DRM for rendering
        - EGLFS : OpenGL ES for rendering
        - XCB   : X11 based, support QtWebEngine
            + Qt WebGL demo: qt5-nmapper
            + Qt VNC demo: qt5-smarthome
    - 2018-09-05: Added Android 8.1
        - AOSP version: android-8.1.0_r41
        - Linux kernel 4.4.126
        - AndroidNN GPU
        - Rockchip Tensorflow Lite物品识别Demo: TfLiteCameraDemo (启动前须先连接CAM1320或USB摄像头)
  
- [Source - github](https://github.com/friendlyarm)

- [Download](http://download.friendlyarm.com/NanoPC-T4)
    - [Flash images - pan.baidu.com](https://pan.baidu.com/s/1rZmMQEQL1tu15R6IeYrksw)
    - [Android7 source - gitlab](https://gitlab.com/friendlyelec/rk3399-nougat.git)
    - [Lubuntu kernel  - github](https://github.com/friendlyarm/kernel-rockchip)

    - **NOTE**: flashing eMMC with upgrade_tool (LinuxUpgradeTool-1.27)
        * Usb device is **2207:330c** (vid:pid)
        ```Bash
        root@aadev:~# lsusb
        Bus 001 Device 002: ID 2207:330c
        Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
        Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
        root@aadev:~# upgrade_tool
        List of rockusb connected
        DevNo=1	Vid=0x2207,Pid=0x330c,LocationID=101	Loader
        Found 1 rockusb,Select input DevNo,Rescan press <R>,Quit press <Q>:q
        ```
    - Friendly Desktop
        - user/pass: pi/pi, root/fa

## Board 2: FireFly-RK3399

- [Getting Start](http://wiki.t-firefly.com/zh_CN/Firefly-RK3399/started.html)

- [Download](http://www.t-firefly.com/doc/download/3.html)
    - [Ubuntu 16.04](http://wiki.t-firefly.com/zh_CN/Firefly-RK3399/linux_compile_gpt.html)
    - [Flint OS for Firefly](https://fydeos.com/)
        - Based on Chromium OS

## Board 3: VS-RK3399

- [VS-RK3399/3288应用方案](http://bbs.videostrong.com/portal.php?&page=1)
    - [VS-RK3399 Android 7.1 HDMI高清输入](http://bbs.videostrong.com/portal.php?mod=view&aid=13)
        1. 支持4K VP9 and 4K 10bits H265/H264 视频解码，高达60fps
        2. 1080P 多格式视频解码 (VC-1, MPEG-1/2/4, VP8)
        3. 1080P 视频编码，支持H.264，VP8格式
        4. 视频后期处理器：反交错、去噪、边缘/细节/色彩优化
        5. HDMI2.0接口、H.265/H.264/VP9 4K@60fps高清视频解码和显示
        > 对VR类智能设备：VS3399具备20ms毫秒延时、90Hz刷新率、4K UHD解码、2K低余晖(Low Persistence)屏幕、高精度定位跟踪系统、超强HDR摄像技术、超强的3D处理能力以及超高清H.265/H.264视频解析能力的硬件优势。