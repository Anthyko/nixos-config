{ self, ... }:
{
  #shared module for all the home configs
  flake.homeModules.base =
    { ... }:
    {

      imports = [
        ../../../home-manager/common/programs/nixvim.nix
      ];
    };

  flake.homeModules.base-desktop =
    { ... }:
    {

      imports = [
        self.homeModules.base
        self.homeModules.niri
        self.homeModules.terminal
        self.homeModules.multimedia-player
      ];
    };
}
