{ inputs, self, ... }:
let
  system = "x86_64-linux";

  pkgsFor = system: import inputs.nixpkgs { inherit system; };

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

  flake.homeConfigurations = {
    revan = mkHMOnly "revan";
  };
}
