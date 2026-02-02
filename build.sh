#!/usr/bin/env bash

set -euo pipefail
# Control Nix's internal parallelism. 0 = auto (use nix.conf settings).
# Example override: NIX_MAX_JOBS=8 ./build.sh
NIX_MAX_JOBS="${NIX_MAX_JOBS:-2}"
##################################
# Build Targets Configuration
##################################

##################################
# Dynamic Target Discovery
##################################

get_nixos_targets() {
  nix flake show --json | jq -r '.nixosConfigurations | keys[]?'
}

get_hm_targets() {
  nix eval .#homeConfigurations --apply 'builtins.attrNames' --json | jq -r '.[]'
}
##################################
# Cachix Setup
##################################

setup_cachix() {
  if [[ -n "${CACHIX_NAME:-}" && -n "${CACHIX_AUTH_TOKEN:-}" ]]; then
    echo "🔐 Enabling Cachix for $CACHIX_NAME"
    cachix authtoken "$CACHIX_AUTH_TOKEN"
    cachix use "$CACHIX_NAME"
  else
    echo "ℹ️ Cachix not enabled (missing environment variables)"
  fi
}


cleanup_store() {
  echo "🧹 Running Nix GC to free disk space"
  nix store gc || true
}
##################################
# Home Manager Build
##################################

build_home_manager() {
  local targets
  targets=($(get_hm_targets))
  if [[ ${#targets[@]} -eq 0 ]]; then
    echo "ℹ️ No Home Manager targets found"
    return
  fi
  echo "🏠 Building Home Manager configurations:"
  local args=()
  for user in "${targets[@]}"; do
    echo "  🔧 .#homeConfigurations.${user}.activationPackage"
    args+=(".#homeConfigurations.${user}.activationPackage")
  done
  nix build --max-jobs 2 "${args[@]}" --out-link ./result-hm
  nix path-info --recursive ./result-hm | cachix push "$CACHIX_NAME"

}

##################################
# NixOS Build
##################################

build_nixos() {
 local hosts=()


  if [[ $# -gt 0 ]]; then
    hosts=("$@")
    echo "🎯 Using provided hosts: ${hosts[*]}"
  else
    # if no args then target all the nixos configs
    mapfile -t hosts < <(get_nixos_targets || true)
    if [[ ${#hosts[@]} -eq 0 ]]; then
      echo "ℹ️ No NixOS targets found"
      return
    fi
    echo "🧩 NixOS targets: ${hosts[*]}"
  fi

  echo "🧩 NixOS targets: ${hosts[*]}"
  local args=()
  for host in "${hosts[@]}"; do
    echo "  🔧 .#nixosConfigurations.${host}.config.system.build.toplevel"
    args+=(".#nixosConfigurations.${host}.config.system.build.toplevel")
  done

  # Single build for all hosts; nix handles parallelism
  nix build --accept-flake-config --keep-going --max-jobs "${NIX_MAX_JOBS}" --no-link "${args[@]}"

  if [[ -n "${CACHIX_NAME:-}" ]]; then
    nix path-info --recursive "${args[@]}" | cachix push "$CACHIX_NAME"
  fi
}
##################################
# Main
##################################

main() {
  echo "🚀 Starting flake build"
  setup_cachix

  SECONDS=0

  build_home_manager
  build_nixos aurele
  cleanup_store

  duration=$SECONDS
  printf "✅ Build completed in %02d:%02d\n" $((duration/60)) $((duration%60))
}

main
