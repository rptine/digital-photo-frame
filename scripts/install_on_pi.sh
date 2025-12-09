#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"

CONFIG_FILE="${ROOT_DIR}/config.env"

if [ ! -f "${CONFIG_FILE}" ]; then
  echo "config.env not found at ${CONFIG_FILE}"
  echo "Please create it from config.env.example and rerun."
  exit 1
fi

# shellcheck disable=SC1090
source "${CONFIG_FILE}"

PI_USER="${PI_USER:-pi}"
FRAME_DIR="${FRAME_DIR:-/home/${PI_USER}/Pictures/frame}"
REPO_DIR="${ROOT_DIR}"

echo "Using PI_USER=${PI_USER}"
echo "Using FRAME_DIR=${FRAME_DIR}"
echo "Repo directory: ${REPO_DIR}"

echo "Updating Raspberry Pi..."
sudo apt update && sudo apt upgrade -y

echo "Installing dependencies (git, feh, python3-pip)..."
sudo apt install -y git feh python3-pip

echo "Installing icloudpd via pip3..."
sudo pip3 install icloudpd

echo "Creating photo directory at ${FRAME_DIR}..."
mkdir -p "${FRAME_DIR}"

echo "Making scripts executable..."
chmod +x "${REPO_DIR}/scripts/"*.sh

echo "Copying systemd services..."
sudo cp "${REPO_DIR}/systemd/icloud-sync.service" /etc/systemd/system/
sudo cp "${REPO_DIR}/systemd/slideshow.service" /etc/systemd/system/

echo "Reloading systemd..."
sudo systemctl daemon-reload

echo "Enabling services..."
sudo systemctl enable icloud-sync.service
sudo systemctl enable slideshow.service

echo
echo "✅ Base install complete."
echo
echo "Next steps (one time only):"
echo "1) Authenticate with iCloud (2FA):"
echo "   icloudpd --username \"${ICLOUD_USERNAME}\" --directory \"${FRAME_DIR}\" --auth-only"
echo
echo "2) Start the iCloud sync service:"
echo "   sudo systemctl start icloud-sync.service"
echo
echo "3) Start the slideshow service:"
echo "   sudo systemctl start slideshow.service"
echo
echo "From now on, both services will start automatically on boot."
