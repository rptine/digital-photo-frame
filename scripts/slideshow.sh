#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
CONFIG_FILE="${ROOT_DIR}/config.env"

if [ -f "${CONFIG_FILE}" ]; then
  # shellcheck disable=SC1090
  source "${CONFIG_FILE}"
fi

FRAME_DIR="${FRAME_DIR:-/home/pi/Pictures/frame}"

# Small delay to ensure desktop is ready
sleep 5

echo "Starting slideshow from ${FRAME_DIR}..."

feh \
  --fullscreen \
  --borderless \
  --hide-pointer \
  --auto-rotate \
  --slideshow-delay 10 \
  --reload 60 \
  --randomize \
  "${FRAME_DIR}"
