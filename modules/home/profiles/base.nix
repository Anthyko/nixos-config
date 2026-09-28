{ self, ... }:
{
  #shared module for all the home configs
  flake.homeModules.base =
    { ... }:
    {
      nix.settings.trusted-users = [
        "root"
        "anthony"
      ];

      imports = [
        self.homeModules.base-home-cli
      ];
      # Add ~/.local/bin to the user's PATH.
      home.sessionPath = [
        "$HOME/.local/bin"
      ];
    };

  flake.homeModules.base-desktop = {

    services = {
      swayidle.enable = true; # idle management daemon
      polkit-gnome.enable = true; # polkit
      gammastep = {
        enable = true;
        latitude = "43.580799";
        longitude = "7.123900";
        temperature.day = 5200;
        temperature.night = 3600;
        tray = true;
      };

    };
    imports = [
      self.homeModules.base
      self.homeModules.terminal
      self.homeModules.multimedia-player
    ];

  };
  # cli apps shared among all the home-manager base config
  # for apps use accross all the nixos systems use the nixos-modules cli-apps
  # this has to be as small has possible
  flake.homeModules.base-home-cli =
    { pkgs, ... }:
    {
      imports = [
        self.homeModules.shell
        self.homeModules.text-editor
      ];
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep 3";
      };
      programs.git = {
        # not sure this should be here
        enable = true;
        settings.user = {
          email = "16465475+dat-Antho@users.noreply.github.com";
          name = "anthony";
        };
      };
      services.ssh-agent.enable = true;
    };
}
