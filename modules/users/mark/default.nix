{ self, ... }:

{

  flake.homeModules.mark-module =
    { ... }:
    {
      imports = [
        self.homeModules.base
      ];

      home = {
        username = "anthony";
        homeDirectory = "/home/anthony";

        # You should not change this value, even if you update Home Manager. If you do
        # want to update the value, then make sure to first check the Home Manager
        # release notes.
        stateVersion = "24.11"; # Please read the comment before changing.
        sessionVariables = {
          EDITOR = "nvim";
        };

      };
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
}
