{ self, ... }:
{
  #shared module for all the home configs
  flake.homeModules.base =
    { ... }:
    {
      nix.settings.trusted-users = [
        "root"
        "anthony"
      ];

      imports = [
        self.homeModules.cli-apps
      ];
    };

  flake.homeModules.base-desktop =
    { pkgs, ... }:
    {

      imports = [
        self.homeModules.base
        self.homeModules.niri
        self.homeModules.terminal
        self.homeModules.multimedia-player
      ];

      home.packages = with pkgs; [
        thunderbird
        signal-desktop
        mumble
        discord
        filezilla
        cryptomator
        anki
        vial # keyboard config
        proton-vpn
        obsidian
      ];
    };
}
