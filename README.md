[![sync](https://github.com/dat-Antho/nixos-config/actions/workflows/sync.yml/badge.svg?branch=master)](https://github.com/dat-Antho/nixos-config/actions/workflows/sync.yml)
[![Flake-bump](https://github.com/dat-Antho/nixos-config/actions/workflows/flake-bump.yml/badge.svg?branch=master)](https://github.com/dat-Antho/nixos-config/actions/workflows/flake-bump.yml)   [![Flake-check](https://github.com/dat-Antho/nixos-config/actions/workflows/flake-check.yml/badge.svg?branch=master)](https://github.com/dat-Antho/nixos-config/actions/workflows/flake-check.yml) 
[![Build-configs](https://github.com/Anthyko/nixos-config/actions/workflows/build.yml/badge.svg)](https://github.com/Anthyko/nixos-config/actions/workflows/build.yml)





## Nixos config

### Nixos 
Zeno : main pc

Aurele : laptop 

Mark : vps
### Home-manager


Revan : dev vm


# Todo first : Enable flakes

https://nixos.wiki/wiki/flakes


# Home manager only systems

```
# /etc/nix/nix.conf
trusted-users = root anthony

substituters = https://datantho-nixos.cachix.org https://dat-antho-shared.cachix.org https://dat-antho-mark.cachix.org https://dat-antho-zeno.cachix.org https://dat-antho-aurele.cachix.org https://cache.nixos.org https://nix-community.cachix.org

trusted-public-keys = datantho-nixos.cachix.org-1:e1Wvy2MQcqrTm5Vedsat55IrNNZRqYvJppfbjMECXOE= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= dat-antho-shared.cachix.org-1:OwZBh4RgqUCqhpPTLfOobK9ZZ+J00O/QElfty7ugyJE= dat-antho-mark.cachix.org-1:RM8g7Bt+5ZMNEr0lDbdZgSwlkjxmkJhNch9YJma+5Bc= dat-antho-aurele.cachix.org-1:fBRYiSUL8AHbNC45x6BZpgc3bJpztGT7tp5p615zW7s= dat-antho-zeno.cachix.org-1:9ULNh7pIZKUoY4GuMLEfkuZgNFH/bmfrQEM/6eHgS7g=

```

Build with : nh home switch --accept-flake-config ~/nixos-config -c revan or home-manager switch --flake .#revan


## For nixos systems

- move /etc/nix/nixos/* into the nixos-configs directory
- update the flake to configure the nixos system
- nixos-rebuild switch --flake .#aurele (example to build aurele)

