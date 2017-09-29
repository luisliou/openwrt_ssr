include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksr-libev
PKG_VERSION:=2.5.6
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/ToyoDAdoubi/shadowsocksr-libev.git
PKG_SOURCE_VERSION:=bf324d848cffa0b5b567cfa6d31c0fb1ec096ec6
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION)

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=breakwa11

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)/$(PKG_SOURCE_SUBDIR)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Lightweight Secured Socks5 Proxy (OpenSSL)
  VARIANT:=openssl
  URL:=https://github.com/shadowsocksr/shadowsocksr-libev
  DEPENDS:=+libopenssl +libpcre +libpthread +zlib +libsodium
endef

define Package/$(PKG_NAME)/description
ShadowsocksR-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
cat > /etc/config/shadowsockr << EOF
{
    "server":"1.1.1.1",
    "server_port":8192,
    "local_address":"0.0.0.0",
    "local_port":1080,
    "password": "password",
    "timeout": 120,
    "method": "none",
    "protocol": "auth_chain_a",
    "protocol_param": "",
    "obfs": "tls1.2_ticket_auth",
    "obfs_param": "cloudflare.com"
}
EOF
cat > /etc/init.d/shadowsockr << EOF
#!/bin/sh /etc/rc.common

START=95

SERVICE_USE_PID=1
SERVICE_WRITE_PID=1
SERVICE_DAEMONIZE=1

CONFIG=/etc/config/shadowsocksr

start() {
#service_start /usr/bin/ss-local -c $CONFIG -b 0.0.0.0
service_start /usr/bin/ss-redir -c $CONFIG -b 0.0.0.0
service_start /usr/bin/ss-tunnel -c $CONFIG -b 0.0.0.0 -l      5353 -L 203.98.129.1:53 -u
}

stop() {
#service_stop /usr/bin/ss-local
service_stop /usr/bin/ss-redir
service_stop /usr/bin/ss-tunnel
}

EOF
endef

CONFIGURE_ARGS += --disable-documentation 

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local $(1)/usr/bin/ss-local
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir $(1)/usr/bin/ss-redir
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local $(1)/usr/bin/ss-tunnel
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/ssr.config $(1)/etc/config/ssr
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/shadowsocksr.init $(1)/etc/init.d/shadowsocksr
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
