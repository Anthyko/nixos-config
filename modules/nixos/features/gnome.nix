_: {

  flake.nixosModules.gnome =
    { pkgs, ... }:
    {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      environment.systemPackages = [ pkgs.gnomeExtensions.appindicator ];
      environment.gnome.excludePackages = with pkgs; [
        atomix # puzzle game
        evince # document viewer
        gedit # text editor
        gnome-characters
        gnome-terminal
        gnome-tour
      ];
    };
}
