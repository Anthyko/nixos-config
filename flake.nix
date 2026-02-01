{
  description = "Nixos and home-manager shared config";

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
    stylix = {
      url = "github:danth/stylix";
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
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixvim
    , disko
    , stylix
    , ...
    }:
    let
      system = "x86_64-linux";

      commonBaseModules = [
        home-manager.nixosModules.home-manager
        ./nixos-configs/common-modules/syncthing.nix
        ./nixos-configs/common-modules/ntp.nix
        ./nixos-configs/common-modules/nix.nix
        ./nixos-configs/common-modules/ssh-agent.nix
        ./nixos-configs/common-modules/dns.nix
      ];

      commonDesktopModules = [
        stylix.nixosModules.stylix
        ./nixos-configs/common-modules/hyprland.nix
        ./nixos-configs/common-modules/desktop-env.nix
      ];

      hmCommonBaseModules = [
        nixvim.homeModules.nixvim
        ./home-manager/common/programs/nixvim.nix
      ];

      hmCommonDesktopModules = [
        ./home-manager/common/programs/hyprland.nix
        ./home-manager/common/programs/foot.nix
        ./home-manager/common/programs/mpv.nix
      ];

      mkNixos =
        { name
        , user ? "anthony"
        , home-manager-directory
        , extraModules ? [ ]
        , desktop ? false
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules =
            (commonBaseModules
              ++ (if desktop then commonDesktopModules else [ ])
              ++ [
              ./nixos-configs/${name}/configuration.nix

              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "";

                home-manager.sharedModules =
                  hmCommonBaseModules
                    ++ (if desktop then hmCommonDesktopModules else [ ]);

                home-manager.users.${user} =
                  import ./home-manager/${home-manager-directory}/home.nix;

                nix.settings.trusted-users = [ "root" user ];
              }
            ]
              ++ extraModules);
        };

      mkNixosHost = args: mkNixos (args // { desktop = true; });
      mkNixosHeadless = args: mkNixos (args // { desktop = false; });
      mkHMOnly =
        name:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
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
          extraModules = [ ];
        };
        aurele = mkNixosHost {
          name = "aurele";
          home-manager-directory = "aurele";
          extraModules = [ ];
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

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
    };
}
