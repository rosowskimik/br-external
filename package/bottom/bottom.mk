################################################################################
#
# bottom
#
################################################################################

BOTTOM_VERSION = 0.11.2
BOTTOM_SITE = $(call github,ClementTsang,bottom,$(BOTTOM_VERSION))
BOTTOM_LICENSE = MIT
BOTTOM_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_BASH_COMPLETION),y)
BOTTOM_CARGO_ENV += "BTM_GENERATE=true"
endif

$(eval $(cargo-package))
