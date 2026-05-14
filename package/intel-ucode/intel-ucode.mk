################################################################################
#
# intel-ucode
#
################################################################################

INTEL_UCODE_VERSION = $(INTEL_MICROCODE_VERSION)
INTEL_UCODE_SITE = $(INTEL_MICROCODE_SITE)
INTEL_UCODE_SOURCE = intel-microcode-$(INTEL_MICROCODE_VERSION).tar.gz
INTEL_UCODE_LICENSE = $(INTEL_MICROCODE_LICENSE)
INTEL_UCODE_LICENSE_FILES = $(INTEL_MICROCODE_LICENSE_FILES)
INTEL_UCODE_REDISTRIBUTE = $(INTEL_MICROCODE_REDISTRIBUTE)
INTEL_UCODE_DEPENDENCIES = host-iucode-tool

INTEL_UCODE_DL_SUBDIR = intel-microcode

INTEL_UCODE_INSTALL_STAGING = NO
INTEL_UCODE_INSTALL_TARGET = NO
INTEL_UCODE_INSTALL_IMAGES = YES

define INTEL_UCODE_BUILD_CMDS
	$(RM) -f $(@D)/intel-ucode{,-with-caveats}/list
	mkdir -p $(@D)/kernel/x86/microcode
	(cd $(@D); \
		$(HOST_DIR)/sbin/iucode_tool --write-earlyfw=$(BUILD_DIR)/intel-ucode.img intel-ucode{,-with-caveats}/ \
	)
endef

define INTEL_UCODE_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(BUILD_DIR)/intel-ucode.img $(BINARIES_DIR)/intel-ucode.img
endef

$(eval $(generic-package))
