#!/usr/bin/env bash

set -euo pipefail

echo "🔄 Running flake update..."
nix  --accept-flake-config flake update

echo "🔍 Checking for flake.lock changes..."
if git diff --exit-code flake.lock > /dev/null; then
  echo "✅ No changes detected" 
else
  echo "🚀 flake.lock was updated"
fi

