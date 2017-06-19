ShadowsocksR-libev for OpenWrt/LEDE
===

简介
---

 本项目是 [shadowsocksr-libev][1] 在 OpenWrt/LEDE 上的移植  

特性
---

软件包只包含 [shadowsocksr-libev][1] 的可执行文件, 可与 [luci-app-shadowsocks][3] 搭配使用

 - shadowsocks-libev

   ```
   客户端/
   └── usr/
       └── bin/
           ├── ss-local       // 提供 SOCKS 代理
           ├── ss-redir       // 提供透明代理, 从 v2.2.0 开始支持 UDP
           └── ss-tunnel      // 提供端口转发, 可用于 DNS 查询
   ```

编译
---

 - 从 OpenWrt 的 [SDK][S] 编译

   ```bash
   # 以 ar71xx 平台为例
   tar xjf OpenWrt-SDK-ar71xx-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
   cd OpenWrt-SDK-ar71xx-*
   git clone https://github.com/Hill-98/shadowsocksr-libev_openwrt package/shadowsocksr-libev
   # 选择要编译的包 Network -> shadowsocksr-libev
   make menuconfig
   # 开始编译
   make package/shadowsocksr-libev/compile V=99
   ```
 - 可手动修改 Makefile 的 PKG_SOURCE_VERSION 值为 [shadowsocksr-libev][1] 最新的 commit 来编译最新版本
配置
---

   软件包本身并不包含配置文件, 配置文件内容为 JSON 格式, 支持的键:  

   键名           | 数据类型 | 说明
   ---------------|----------|-----------------------------------------------
   server         | 字符串   | 服务器地址, 可以是 IP 或者域名
   server_port    | 整数值   | 服务器端口号
   local_address  | 字符串   | 本地绑定的 IP 地址, 默认 `127.0.0.1`
   local_port     | 整数值   | 本地绑定的端口号
   password       | 字符串   | 服务端设置的密码
   method         | 字符串   | 加密方式
   timeout        | 整数值   | 超时时间（秒）, 默认 60
   protocol       | 字符串   | 协议, eg: `auth_aes128_sha1`
   protocol_param | 整数值   | 协议参数
   obfs           | 字符串   | 混淆方式, eg: `tls1.2_ticket_auth`
   obfs_param     | 字符串   | 混淆参数，eg: `cloudflare.com`
   fast_open      | 布尔值   | 是否启用 [TCP Fast Open][F], 只适用于 `ss-local`
   nofile         | 整数值   | 设置 Linux ulimit
   mode           | 枚举值   | 转发模式, 可用值: [`tcp_only`, `udp_only`, `tcp_and_udp`]
   mptcp          | 布尔值   | 是否启用 [Multipath TCP][M]


  [1]: https://github.com/shadowsocksr/shadowsocksr-libev
  [3]: https://github.com/shadowsocks/luci-app-shadowsocks
  [F]: https://github.com/shadowsocks/shadowsocks/wiki/TCP-Fast-Open
  [S]: https://wiki.openwrt.org/doc/howto/obtain.firmware.sdk
  [M]: https://www.multipath-tcp.org/
