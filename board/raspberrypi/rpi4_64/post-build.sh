#!/bin/sh
set -eu

# boot directly from initramfs
if [ -d ${TARGET_DIR}/etc/systemd ]; then
  rm -fv ${TARGET_DIR}/etc/initrd-release
fi
