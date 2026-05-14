################################################################################
#
# iucode-tool
#
################################################################################

IUCODE_TOOL_VERSION = 2.3.1
IUCODE_TOOL_SITE = $(call gitlab,iucode-tool,iucode-tool,v$(IUCODE_TOOL_VERSION))
IUCODE_TOOL_LICENSE = GPL-2.0
IUCODE_TOOL_AUTORECONF = YES

$(eval $(host-autotools-package))
