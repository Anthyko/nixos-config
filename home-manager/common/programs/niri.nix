{ config, pkgs, ... }:

{
  imports = [
    ./foot.nix
    ./waybar.nix
  ];
  programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
  programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
  programs.waybar.enable = true; # launch on startup in the default setting (bar)
  services.swayidle.enable = true; # idle management daemon
  services.polkit-gnome.enable = true; # polkit
  home.packages = with pkgs; [
    swaybg # wallpaper
    xwayland-satellite
    networkmanagerapplet # network manager
    pavucontrol # audio control
  ];
  # used niri config file
  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;
  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita"; # Ou "Breeze", "Bibata-Modern-Ice", "Capitaine Cursors", etc.
    package = pkgs.adwaita-icon-theme;
    size = 50;
  };

  services.gammastep = {
    enable = true;
    latitude = "43.580799";
    longitude = "7.123900";
    temperature.day = 5200;
    temperature.night = 3600;
    tray = true;
  };

  services.mako = {
    # Notifications
    enable = true;
    settings = {

      default-timeout = 5000; #  milliseconds
    };
  };
}
