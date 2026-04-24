{ inputs, self, ... }: {
  #shared module for all the home configs
  flake.homeModules.base = { inputs, pkgs, ... }: {

    imports = [
      ../../../home-manager/common/programs/nixvim.nix
    ];
  };

  flake.homeModules.base-desktop = { inputs, ... }: {

    imports = [
      self.homeModules.niri
      self.homeModules.terminal
    ];
  };
}
