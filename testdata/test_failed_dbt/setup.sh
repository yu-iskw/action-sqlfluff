#!/bin/bash
set -e

readonly SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

pip install -r "${SCRIPT_DIR}/requirements.txt"
