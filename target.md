```bash
# desired dir organisation
├── flake.lock
├── flake/
│   ├── default.nix
│   ├── nixos.nix
│   ├── homes.nix
│   ├── packages.nix
│   ├── devshells.nix
│   └── checks.nix
├── hosts/
│   ├── mark/
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   ├── disk-config.nix
│   │   └── modules/
│   ├── zeno/
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   └── modules/
│   └── aurele/
│       ├── default.nix
│       ├── hardware-configuration.nix
│       └── modules/
├── home/
│   ├── anthony/default.nix
│   ├── aurele/default.nix
│   ├── mark/default.nix
│   ├── revan/default.nix
│   └── common/
├── modules/
│   ├── nixos/
│   ├── home-manager/
│   └── shared/
├── secrets/
├── scripts/
│   ├── build.sh
│   └── flake-bump.sh
└── README.md

```

