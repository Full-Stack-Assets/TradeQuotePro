#!/bin/bash
set -euo pipefail
exec "$(dirname "$0")/scripts/switch-app.sh" "$@"
