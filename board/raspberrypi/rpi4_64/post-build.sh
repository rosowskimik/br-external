#!/bin/sh
set -eu

# LINUX_IMAGE_NAME
KERNEL="$2"

# boot directly from initramfs
if [ -d ${target_dir}/etc/systemd ]; then
  rm -fv ${target_dir}/etc/initrd-release
fi
