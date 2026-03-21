{
  description = "NixOS and Home Manager shared config";

  nixConfig = {
    substituters = [
      "https://datantho-nixos.cachix.org"
      "https://dat-antho-shared.cachix.org"
      "https://dat-antho-mark.cachix.org"
      "https://dat-antho-zeno.cachix.org"
      "https://dat-antho-aurele.cachix.org"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "datantho-nixos.cachix.org-1:e1Wvy2MQcqrTm5Vedsat55IrNNZRqYvJppfbjMECXOE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "dat-antho-shared.cachix.org-1:OwZBh4RgqUCqhpPTLfOobK9ZZ+J00O/QElfty7ugyJE="
      "dat-antho-mark.cachix.org-1:RM8g7Bt+5ZMNEr0lDbdZgSwlkjxmkJhNch9YJma+5Bc="
      "dat-antho-aurele.cachix.org-1:fBRYiSUL8AHbNC45x6BZpgc3bJpztGT7tp5p615zW7s="
      "dat-antho-zeno.cachix.org-1:9ULNh7pIZKUoY4GuMLEfkuZgNFH/bmfrQEM/6eHgS7g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , flake-parts
    , nixpkgs
    , home-manager
    , nixvim
    , disko
    , stylix
    , sops-nix
    , ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake =
        let
          system = "x86_64-linux";
          lib = nixpkgs.lib;

          pkgsFor = system: import nixpkgs { inherit system; };

          commonBaseModules = [
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops

            ./nixos-configs/common-modules/syncthing.nix
            ./nixos-configs/common-modules/ntp.nix
            ./nixos-configs/common-modules/nix.nix
            ./nixos-configs/common-modules/ssh-agent.nix
            ./nixos-configs/common-modules/dns.nix
            ./nixos-configs/common-modules/tailscale.nix
            ./nixos-configs/common-modules/sops.nix
          ];

          commonDesktopModules = [
            stylix.nixosModules.stylix
            ./nixos-configs/common-modules/desktop-env.nix
            ./nixos-configs/common-modules/niri.nix
          ];

          hmCommonBaseModules = [
            nixvim.homeModules.nixvim
            ./home-manager/common/programs/nixvim.nix
          ];

          hmCommonDesktopModules = [
            ./home-manager/common/programs/niri.nix
            ./home-manager/common/programs/foot.nix
            ./home-manager/common/programs/mpv.nix
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
                  ./nixos-configs/${name}/configuration.nix

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
                      import ./home-manager/${home-manager-directory}/home.nix;

                    nix.settings.trusted-users = [ "root" user ];
                  }
                ]
                ++ extraModules;
            };

          mkNixosHost = args: mkNixos (args // { desktop = true; });
          mkNixosHeadless = args: mkNixos (args // { desktop = false; });

          mkHMOnly =
            name:
            home-manager.lib.homeManagerConfiguration {
              pkgs = pkgsFor system;

              extraSpecialArgs = {
                inherit inputs self;
              };

              modules = [
                ./home-manager/${name}/home.nix
                nixvim.homeModules.nixvim
                ./home-manager/common/programs/nixvim.nix
              ];
            };
        in
        {
          nixosConfigurations = {
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
              extraModules = [ disko.nixosModules.disko ];
            };
          };

          homeConfigurations = {
            revan = mkHMOnly "revan";
          };
        };

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
