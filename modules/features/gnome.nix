{ inputs
, self
, lib
, ...
}:
{


  flake.nixosModules.gnome = { inputs, pkgs, ... }: {
 services.displayManager.gdm.enable = true;
    stylix = {
      enable = true;

      # Palette Gruvbox Dark Medium
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    };
  services.desktopManager.gnome.enable = true;
      environment.systemPackages = [ pkgs.gnomeExtensions.appindicator ];
  };
}
