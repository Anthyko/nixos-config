{ self, ... }:
{
  flake.homeModules.aurele-module =
    { pkgs, ... }:
    {
      imports = [
        self.homeModules.base-desktop
      ];
      home.username = "anthony";
      home.homeDirectory = "/home/anthony";

      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "24.11"; # Please read the comment before changing.
      home.packages = with pkgs; [
        qbittorrent
        wine
      ];
      programs.bash.enable = true;
      home.sessionVariables = {
        EDITOR = "nvim";
      };
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

    };
}
