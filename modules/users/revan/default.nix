{
  self,
  mkHome,
  system,
  ...
}:

{
  flake = {
    homeConfigurations.revan = mkHome "x86_64-linux" [
      self.homeModules.revan-module
    ];

    homeModules.revan-module =
      { pkgs, ... }:
      {
        imports = [
          self.homeModules.cli-apps
          self.homeModules.python
        ];

        # Home Manager needs a bit of information about you and the paths it should
        # manage.
        home.username = system.users.dev;
        home.homeDirectory = "/home/${system.users.dev}";

        # This value determines the Home Manager release that your configuration is
        # compatible with. This helps avoid breakage when a new Home Manager release
        # introduces backwards incompatible changes.
        #
        # You should not change this value, even if you update Home Manager. If you do
        # want to update the value, then make sure to first check the Home Manager
        # release notes.
        home.stateVersion = "24.11"; # Please read the comment before changing.

        # The home.packages option allows you to install Nix packages into your
        # environment.
        home.packages = with pkgs; [
          zellij
          k9s
        ];

        home.sessionVariables = {
          EDITOR = "nvim";
          LD_LIBRARY_PATH = "";
          LIBRARY_PATH = "";

        };
        programs.zsh.shellAliases = {
          hmrs = "nh home switch --accept-flake-config ~/nixos-config -c revan";
        };
        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;
      };
  };
}
