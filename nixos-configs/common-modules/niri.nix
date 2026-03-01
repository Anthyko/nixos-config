{ config
, pkgs
, lib
, ...
}:
{
  # niri deps
  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service
programs.niri.enable = true;
  programs.xwayland.enable = true;
}
