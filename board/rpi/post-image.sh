#!/bin/bash
set -eo pipefail

GENIMAGE_CFG_IN="${BR2_EXTERNAL_RPI_PATH}/board/rpi/genimage.cfg.in"
GENIMAGE_CFG="${BINARIES_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

FILES=()

for i in "${BINARIES_DIR}"/*.dtb "${BINARIES_DIR}"/rpi-firmware/*; do
  FILES+=("${i#${BINARIES_DIR}/}")
done

KERNEL=$(grep "^BR2_LINUX_KERNEL_IMAGE_TARGET_NAME=" "${BR2_CONFIG}" | sed -E 's/.*="(.*)"/\1/')
FILES+=("${KERNEL}")

UBOOT="u-boot.bin"
FILES+=("${UBOOT}")

BOOT_FILES=$(printf '\\t\\t\\t"%s",\\n' "${FILES[@]}")
sed "s|#BOOT_FILES#|${BOOT_FILES}|" "${GENIMAGE_CFG_IN}" \
  >"${GENIMAGE_CFG}"

# Pass an empty rootpath. genimage makes a full copy of the given rootpath to
# ${GENIMAGE_TMP}/root so passing TARGET_DIR would be a waste of time and disk
# space. We don't rely on genimage to build the rootfs image, just to insert a
# pre-built one in the disk image.

trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"

rm -rf "${GENIMAGE_TMP}"

genimage \
  --rootpath "${ROOTPATH_TMP}" \
  --tmppath "${GENIMAGE_TMP}" \
  --inputpath "${BINARIES_DIR}" \
  --outputpath "${BINARIES_DIR}" \
  --config "${GENIMAGE_CFG}"
