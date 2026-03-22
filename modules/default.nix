{ inputs, self, ... }:
let
  system = "x86_64-linux";
  lib = inputs.nixpkgs.lib;

  pkgsFor = system: import inputs.nixpkgs { inherit system; };

  commonBaseModules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops

    self.nixosModules.base
    ../nixos-configs/common-modules/tailscale.nix
    ../nixos-configs/common-modules/sops.nix
  ];

  commonDesktopModules = [
    inputs.stylix.nixosModules.stylix
    ../nixos-configs/common-modules/desktop-env.nix
    ../nixos-configs/common-modules/niri.nix
  ];

  hmCommonBaseModules = [
    inputs.nixvim.homeModules.nixvim
    ../home-manager/common/programs/nixvim.nix
  ];

  hmCommonDesktopModules = [
    ../home-manager/common/programs/niri.nix
    ../home-manager/common/programs/foot.nix
    ../home-manager/common/programs/mpv.nix
  ];

  mkNixos =
    { name
    , user ? "anthony"
    , home-manager-directory
    , extraModules ? [ ]
    , desktop ? false
    , system ? "x86_64-linux"
    }:
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs self;
      };

      modules =
        commonBaseModules
        ++ lib.optionals desktop commonDesktopModules
        ++ [
          ../nixos-configs/${name}/configuration.nix

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "";

            home-manager.sharedModules =
              hmCommonBaseModules
              ++ lib.optionals desktop hmCommonDesktopModules;

            home-manager.extraSpecialArgs = {
              inherit inputs self;
            };

            home-manager.users.${user} =
              import ../home-manager/${home-manager-directory}/home.nix;

            nix.settings.trusted-users = [ "root" user ];
          }
        ]
        ++ extraModules;
    };

  mkNixosHost = args: mkNixos (args // { desktop = true; });
  mkNixosHeadless = args: mkNixos (args // { desktop = false; });

  mkHMOnly =
    name:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor system;

      extraSpecialArgs = {
        inherit inputs self;
      };

      modules = [
        ../home-manager/${name}/home.nix
        inputs.nixvim.homeModules.nixvim
        ../home-manager/common/programs/nixvim.nix
      ];
    };
in
{
  systems = [ system ];
  flake.nixosConfigurations = {
    zeno = mkNixosHost {
      name = "zeno";
      home-manager-directory = "anthony";
    };

    aurele = mkNixosHost {
      name = "aurele";
      home-manager-directory = "aurele";
    };

    mark = mkNixosHeadless {
      name = "mark";
      home-manager-directory = "mark";
      extraModules = [ inputs.disko.nixosModules.disko ];
    };
  };

  flake.homeConfigurations = {
    revan = mkHMOnly "revan";
  };
}

