################################################################################
#
# python-copyparty
#
################################################################################

PYTHON_COPYPARTY_VERSION = 1.18.6
PYTHON_COPYPARTY_SOURCE = copyparty-$(PYTHON_COPYPARTY_VERSION).tar.gz
PYTHON_COPYPARTY_SITE = https://files.pythonhosted.org/packages/ab/fb/95b58ef0848ed78c80fec0e19749f8daccdb848d3dd4294d3ba8b0978845
PYTHON_COPYPARTY_SETUP_TYPE = setuptools
PYTHON_COPYPARTY_LICENSE = MIT
PYTHON_COPYPARTY_LICENSE_FILES = LICENSE copyparty/res/COPYING.txt

$(eval $(python-package))
