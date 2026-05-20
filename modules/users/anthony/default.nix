{ self, ... }:
{
  flake.homeModules.anthony-module = _: {
    imports = [
      ../anthony/../../../home-manager/anthony/home.nix
      self.homeModules.base
      self.homeModules.base-desktop
      self.homeModules.multimedia-player
    ];
    home.username = "anthony";
    home.homeDirectory = "/home/anthony";
    home.stateVersion = "24.05";
    home.sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
    stylix.targets.nixvim.enable = false;
  };
}
