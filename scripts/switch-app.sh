#!/bin/bash
# Usage: ./scripts/switch-app.sh tradequote|inkmanager|invoiceflow

set -euo pipefail

APP="${1:-}"
if [ -z "$APP" ]; then
  echo "Usage: ./scripts/switch-app.sh [tradequote|inkmanager|invoiceflow]"
  exit 1
fi

case "$APP" in
  tradequote|inkmanager|invoiceflow) ;;
  *)
    echo "Invalid app: $APP"
    echo "Usage: ./scripts/switch-app.sh [tradequote|inkmanager|invoiceflow]"
    exit 1
    ;;
esac

if [ ! -d "apps/$APP" ]; then
  echo "App directory not found: apps/$APP"
  exit 1
fi

ln -sfn "apps/$APP" ./active-app
echo "Now deploying: $APP"
