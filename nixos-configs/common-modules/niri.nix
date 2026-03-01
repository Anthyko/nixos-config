{ config
, pkgs
, lib
, ...
}:
{
  # niri deps
  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service

}
