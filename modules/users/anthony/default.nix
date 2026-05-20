{ self, ... }:
{
  flake.homeModules.anthony-module = _: {
    imports = [
      ../anthony/../../../home-manager/anthony/home.nix
      self.homeModules.base
      self.homeModules.base-desktop
      self.homeModules.multimedia-player
    ];
  };
}
