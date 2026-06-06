{ inputs, ... }:
{

  flake.nixosModules.base-desktop = {
    imports =
      (with inputs.self.nixosModules; [
        base
        x-server
        niri
        display-manager
      ])
      ++ [
      ];

    security.polkit.enable = true; # polkit
    services.gnome.gnome-keyring.enable = true; # secret service
    programs.xwayland.enable = true;

  };

  flake.nixosModules.base-desktop-gnome = {
    imports =
      (with inputs.self.nixosModules; [
        x-server
        gnome
        base
      ])
      ++ [
      ];

  };

}
