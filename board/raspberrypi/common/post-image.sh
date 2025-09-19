#!/bin/bash
set -eo pipefail

# LINUX_IMAGE_NAME
KERNEL="$2"

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"

GENIMAGE_CFG_IN="${BR2_EXTERNAL_RPI_PATH}/board/raspberrypi/${BOARD_NAME}/genimage.cfg.in"
GENIMAGE_CFG="${BINARIES_DIR}/genimage.cfg"

FILES=(
  "u-boot.bin"
  "${KERNEL}"
)

for i in "${BINARIES_DIR}"/*.dtb "${BINARIES_DIR}"/rpi-firmware/*; do
  FILES+=("${i#${BINARIES_DIR}/}")
done

BOOT_FILES=$(printf '\\t\\t\\t"%s",\\n' "${FILES[@]}")
sed "s|#BOOT_FILES#|${BOOT_FILES}|" "${GENIMAGE_CFG_IN}" \
  >"${GENIMAGE_CFG}"

support/scripts/genimage.sh -c "${GENIMAGE_CFG}"
