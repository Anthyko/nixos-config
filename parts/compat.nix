{ inputs, ... }:
let
  inherit (inputs) nixpkgs home-manager nixvim disko stylix;

  system = "x86_64-linux";

  commonBaseModules = [
    home-manager.nixosModules.home-manager
    ./../nixos-configs/common-modules/syncthing.nix
    ./../nixos-configs/common-modules/ntp.nix
    ./../nixos-configs/common-modules/nix.nix
    ./../nixos-configs/common-modules/ssh-agent.nix
    ./../nixos-configs/common-modules/dns.nix
  ];

  commonDesktopModules = [
    stylix.nixosModules.stylix
    ./../nixos-configs/common-modules/hyprland.nix
    ./../nixos-configs/common-modules/desktop-env.nix
  ];

  hmCommonBaseModules = [
    nixvim.homeModules.nixvim
    ./../home-manager/common/programs/nixvim.nix
  ];

  hmCommonDesktopModules = [
    ./../home-manager/common/programs/hyprland.nix
    ./../home-manager/common/programs/foot.nix
    ./../home-manager/common/programs/mpv.nix
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
            ./../nixos-configs/${name}/configuration.nix

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "";

              home-manager.sharedModules =
                hmCommonBaseModules
                ++ (if desktop then hmCommonDesktopModules else [ ]);

              home-manager.users.${user} =
                import ./../home-manager/${home-manager-directory}/home.nix;

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
        ./../home-manager/${name}/home.nix
        nixvim.homeModules.nixvim
        ./../home-manager/common/programs/nixvim.nix
      ];
    };
in
{
  flake = {
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
