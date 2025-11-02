#!/usr/bin/env bash
set -eo pipefail

THIS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
RESC_FILE="$(find "${THIS_DIR}/sim" -type f -name "*.resc")"

exec renode \
  --console \
  "${RESC_FILE}"
