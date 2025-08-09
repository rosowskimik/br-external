################################################################################
#
# copyparty
#
################################################################################

COPYPARTY_VERSION = 1.19.1
COPYPARTY_SOURCE = copyparty-$(COPYPARTY_VERSION).tar.gz
COPYPARTY_SITE = https://github.com/9001/copyparty/releases/download/v$(COPYPARTY_VERSION)
COPYPARTY_SETUP_TYPE = setuptools
COPYPARTY_LICENSE = MIT
COPYPARTY_LICENSE_FILES = LICENSE copyparty/res/COPYING.txt

$(eval $(python-package))
