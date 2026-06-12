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

      services = {
        swayidle.enable = true; # idle management daemon
        polkit-gnome.enable = true; # polkit
        gammastep = {
          enable = true;
          latitude = "43.580799";
          longitude = "7.123900";
          temperature.day = 5200;
          temperature.night = 3600;
          tray = true;
        };

      };
      imports = [
        self.homeModules.base
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
