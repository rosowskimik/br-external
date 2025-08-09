################################################################################
#
# caddy
#
################################################################################

CADDY_VERSION = 2.9.1
CADDY_SITE = $(call github,caddyserver,caddy,v$(CADDY_VERSION))
CADDY_LICENSE = Apache-2.0
CADDY_LICENSE_FILES = LICENSE
CADDY_GOMOD = github.com/caddyserver/caddy/v2
CADDY_BUILD_TARGETS = cmd/caddy

define CADDY_INSTALL_DEFAULT_CONFIG
	$(INSTALL) -m 0644 -D $(CADDY_PKGDIR)/Caddyfile \
		$(TARGET_DIR)/etc/caddy
endef
CADDY_POST_INSTALL_TARGET_HOOKS += \
	CADDY_INSTALL_DEFAULT_CONFIG

define CADDY_INSTALL_INIT_SYSTEMD
	$(INSTALL) -m 0644 -D $(CADDY_PKGDIR)/caddy.service \
		$(TARGET_DIR)/usr/lib/systemd/system/caddy.service
	$(INSTALL) -m 0644 -D $(CADDY_PKGDIR)/caddy.tmpfiles \
		$(TARGET_DIR)/usr/lib/tmpfiles.d/caddy.conf
	$(INSTALL) -d $(TARGET_DIR)/etc/caddy/conf.d
endef

define CADDY_USERS
	caddy -1 caddy -1 * /var/lib/caddy - - caddy daemon
endef

$(eval $(golang-package))
