################################################################################
#
# amd-ucode
#
################################################################################

AMD_UCODE_VERSION = $(LINUX_FIRMWARE_VERSION)
AMD_UCODE_SOURCE = $(LINUX_FIRMWARE_SOURCE)
AMD_UCODE_SITE = $(LINUX_FIRMWARE_SITE)
AMD_UCODE_LICENSE_FILES = LICENSE.amd-ucode

AMD_UCODE_DL_SUBDIR = linux-firmware

AMD_UCODE_INSTALL_STAGING = NO
AMD_UCODE_INSTALL_TARGET = NO
AMD_UCODE_INSTALL_IMAGES = YES

define AMD_UCODE_BUILD_CMDS
	mkdir -p $(BUILD_DIR)/kernel/x86/microcode
	cat $(@D)/amd-ucode/microcode_amd*.bin > $(BUILD_DIR)/kernel/x86/microcode/AuthenticAMD.bin
	[ -n "$SOURCE_DATE_EPOCH" ] && touch -d "@${SOURCE_DATE_EPOCH}" $(BUILD_DIR)/kernel/x86/microcode/AuthenticAMD.bin

	(cd $(BUILD_DIR); \
		echo kernel/x86/microcode/AuthenticAMD.bin | \
		cpio --owner=0:0 --reproducible --format=newc -o -O $(BUILD_DIR)/amd-ucode.img \
	)
endef

define AMD_UCODE_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(BUILD_DIR)/amd-ucode.img $(BINARIES_DIR)/amd-ucode.img
endef

$(eval $(generic-package))
