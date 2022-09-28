#!/usr/bin/env bash
set -exo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export PATH="${SCRIPT_DIR}/.local/bin:${PATH}"

TMP=$(mktemp -d -t tmp.XXXXXXXXXX)
echo "Created temporary directory at $TMP"

jsonnet jsonnet/main.jsonnet > "${TMP}/main.json"