#!/bin/bash
set -eo pipefail

RENODE_BOARD_DIR="$(dirname "$0")"
RENODE_BOARD_ARCH_DIR="${RENODE_BOARD_DIR}/$2/sim"

install -Dm 0755 "${RENODE_BOARD_DIR}/runrenode.sh" "${BINARIES_DIR}/runrenode.sh"
cp -rv ${RENODE_BOARD_ARCH_DIR} "${BINARIES_DIR}"
