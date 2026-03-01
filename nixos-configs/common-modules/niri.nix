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
  programs.niri.useNautilus = true;
  programs.xwayland.enable = true;
  stylix = {
    enable = true;

    # Palette Gruvbox Dark Medium
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };


}
