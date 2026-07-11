[![Flake-check](https://github.com/dat-Antho/nixos-config/actions/workflows/flake-check.yml/badge.svg?branch=master)](https://github.com/dat-Antho/nixos-config/actions/workflows/flake-check.yml)
---

# NixOS Configuration

This repository contains a modular NixOS and Home Manager setup built with:

- Nix Flakes
- flake-parts
- nix-wrapper-modules
- import-tree
- sops-nix

The configuration follows a **feature → profile → host/user** architecture.

---

## Machines

### NixOS Hosts

| Host   | Description    |
|--------|----------------|
| zeno   | Main desktop   |
| aurele | Laptop         |
| mark   | VPS / server   |

### Home Manager

| Profile | Description   |
|---------|---------------|
| anthony | Main user     |
| aurele  | Laptop user   |
| mark    | Server user   |
| revan   | Dev VM        |

---

## Architecture

```
features → profiles → hosts / users
```

- features: small reusable modules (ntp, tailscale, etc.)
- profiles: reusable bundles (base, desktop, server)
- hosts: final machine configurations
- users: home-manager configurations
- packages: wrapped packages (nvim, niri, etc.)

---

## Project Structure

### Targeted modules Structure

```
modules/
├── nixos/
│   ├── features/
│   ├── profiles/
├── home/
│   ├── features/
│   ├── profiles/
hosts/
users/
packages/
```

---

## Design Notes

- import-tree is used only for flake modules and reusable components
- hardware configurations are isolated in hardware/
- files prefixed with `_` are ignored by import-tree
- NixOS and Home Manager modules are kept separate
- modules/ contains reusable logic
- Home Manager for configuring CLI tools and shell environments.

---

## Secrets (SOPS)

Required key file:

```
/var/lib/sops-nix/keys.txt
```

### Edit secrets

```
export SOPS_AGE_KEY_FILE=/var/lib/sops-nix/keys.txt
nix-shell -p sops --run "sops secrets/thesecretfile.yaml"

```

---

## Prerequisites

### Enable flakes

https://nixos.wiki/wiki/flakes

### Configure binary caches

Add the following to `/etc/nix/nix.conf`:

```
trusted-users = root anthony

substituters = https://datantho-nixos.cachix.org https://dat-antho-shared.cachix.org https://dat-antho-mark.cachix.org https://dat-antho-zeno.cachix.org https://dat-antho-aurele.cachix.org https://cache.nixos.org https://nix-community.cachix.org

trusted-public-keys = datantho-nixos.cachix.org-1:e1Wvy2MQcqrTm5Vedsat55IrNNZRqYvJppfbjMECXOE= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= dat-antho-shared.cachix.org-1:OwZBh4RgqUCqhpPTLfOobK9ZZ+J00O/QElfty7ugyJE= dat-antho-mark.cachix.org-1:RM8g7Bt+5ZMNEr0lDbdZgSwlkjxmkJhNch9YJma+5Bc= dat-antho-aurele.cachix.org-1:fBRYiSUL8AHbNC45x6BZpgc3bJpztGT7tp5p615zW7s= dat-antho-zeno.cachix.org-1:9ULNh7pIZKUoY4GuMLEfkuZgNFH/bmfrQEM/6eHgS7g=
```

---

## Usage

### NixOS systems

#### Using nh (recommended)

Switch:

```
nh os switch .#<host>
```

Example:

```
nh os switch .#zeno
```

Dry run:

```
nh os test .#zeno
```

Build only:

```
nh os build .#zeno
```

---

#### Using nixos-rebuild

```
sudo nixos-rebuild switch --flake .#<host>
```

Example:

```
sudo nixos-rebuild switch --flake .#aurele
```

---

### Home Manager

#### Using nh

```
nh home switch .#<user>
```

Example:

```
nh home switch .#revan
```

Dry run:

```
nh home test .#revan
```

Build only:

```
nh home build .#revan
```

---

#### Using Home Manager directly

```
home-manager switch --flake .#<user>
```

Example:

```
home-manager switch --flake .#anthony
```

---

# Todo

- follow : https://github.com/NixOS/nixpkgs/issues/513245
