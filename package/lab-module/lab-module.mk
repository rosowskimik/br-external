################################################################################
#
# lab module
#
################################################################################
LAB_MODULE_VERSION = 1.0
LAB_MODULE_SITE = $(LAB_MODULE_PKGDIR)
LAB_MODULE_SITE_METHOD = local

$(eval $(kernel-module))
$(eval $(generic-package))
