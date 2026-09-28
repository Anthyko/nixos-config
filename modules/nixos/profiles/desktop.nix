{ inputs, ... }:
{

  flake = {
    nixosModules = {
      # software used by all the desktop configs
      base-desktop = {
        imports = with inputs.self.nixosModules; [
          base
          x-server
          communication
          file-encryption
          password-manager
          memory-training
          notes
          vpn
          ebook-library
          music-player
          file-sharing
          office
          qflipper
          terminal
        ];

      };

      base-desktop-niri = {
        imports = with inputs.self.nixosModules; [
          base-desktop
          display-manager
          niri
        ];

        security.polkit.enable = true; # polkit
        services.gnome.gnome-keyring.enable = true; # secret service
        programs.xwayland.enable = true;

      };
      base-desktop-gnome = {
        imports = with inputs.self.nixosModules; [
          base-desktop
          gnome
        ];
      };

    };
  };
}
