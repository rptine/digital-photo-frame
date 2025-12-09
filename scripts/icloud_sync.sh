#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
CONFIG_FILE="${ROOT_DIR}/config.env"

if [ ! -f "${CONFIG_FILE}" ]; then
  echo "config.env not found at ${CONFIG_FILE}"
  exit 1
fi

# shellcheck disable=SC1090
source "${CONFIG_FILE}"

ICLOUD_USERNAME="${ICLOUD_USERNAME:?ICLOUD_USERNAME not set in config.env}"
ALBUM_NAME="${ALBUM_NAME:?ALBUM_NAME not set in config.env}"
FRAME_DIR="${FRAME_DIR:-/home/pi/Pictures/frame}"
SYNC_INTERVAL_SECONDS="${SYNC_INTERVAL_SECONDS:-3600}"
ICLOUDPD_BIN="${ICLOUDPD_BIN:-/usr/local/bin/icloudpd}"

echo "Starting iCloud sync loop:"
echo "  User: ${ICLOUD_USERNAME}"
echo "  Album: ${ALBUM_NAME}"
echo "  Directory: ${FRAME_DIR}"
echo "  Interval: ${SYNC_INTERVAL_SECONDS}s"
echo

"${ICLOUDPD_BIN}" \
  --username "${ICLOUD_USERNAME}" \
  --directory "${FRAME_DIR}" \
  --album "${ALBUM_NAME}" \
  --watch-with-interval "${SYNC_INTERVAL_SECONDS}" \
  --auto-delete
