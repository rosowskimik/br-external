################################################################################
#
# luakit
#
################################################################################
LUAKIT_VERSION = 2.4.0
LUAKIT_SOURCE = luakit-$(LUAKIT_VERSION).tar.gz
LUAKIT_SITE = https://github.com/luakit/luakit/releases/download/$(LUAKIT_VERSION)
LUAKIT_LICENSE = GPL-3.0
LUAKIT_LICENSE_FILES = COPYING.GPLv3

LUAKIT_DEPENDENCIES = host-pkgconf luafilesystem sqlite webkitgtk

LUAKIT_MAKE_ARGS = \
	DEVELOPMENT_PATHS=0 \
	MANPREFIX = "" \
	DOCDIR = ""

ifeq ($(BR2_PACKAGE_LUA),y)
LUAKIT_DEPENDENCIES += lua
LUAKIT_MAKE_ARGS += USE_LUAJIT=0
else
LUAKIT_DEPENDENCIES += luajit
LUAKIT_MAKE_ARGS += USE_LUAJIT=1
endif

define LUAKIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		$(LUAKIT_MAKE_ARGS \
		-C $(@D)
endef

define LUAKIT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		$(LUAKIT_MAKE_ARGS) \
		-C $(@D) install
endef

$(eval $(generic-package))
