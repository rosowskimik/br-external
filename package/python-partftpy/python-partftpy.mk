################################################################################
#
# python-partftpy
#
################################################################################

PYTHON_PARTFTPY_VERSION = 0.4.0
PYTHON_PARTFTPY_SOURCE = partftpy-$(PYTHON_PARTFTPY_VERSION).tar.gz
PYTHON_PARTFTPY_SITE = https://files.pythonhosted.org/packages/8c/96/642bb3ddcb07a2c6764eb29aa562d1cf56877ad6c330c3c8921a5f05606d
PYTHON_PARTFTPY_SETUP_TYPE = setuptools
PYTHON_PARTFTPY_LICENSE = MIT
PYTHON_PARTFTPY_LICENSE_FILES = LICENSE

$(eval $(python-package))
