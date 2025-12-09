#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_FILE="${SCRIPT_DIR}/config.env"
EXAMPLE_CONFIG="${SCRIPT_DIR}/config.env.example"

if [ ! -f "${CONFIG_FILE}" ]; then
  echo "config.env not found."
  if [ -f "${EXAMPLE_CONFIG}" ]; then
    cp "${EXAMPLE_CONFIG}" "${CONFIG_FILE}"
    echo "Created config.env from config.env.example."
  fi
  echo
  echo "👉 Please edit config.env with your Apple ID, album name, and paths, then run:"
  echo "   ./setup.sh"
  exit 1
fi

# Make sure scripts are executable
chmod +x "${SCRIPT_DIR}/scripts/"*.sh

# Run the main install script
"${SCRIPT_DIR}/scripts/install_on_pi.sh"
