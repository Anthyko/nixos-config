{ self, ... }:
{
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
  #shared module for all the nixos using home-manager configs
  flake.homeModules.base =
    { ... }:
    {
      nix.settings.trusted-users = [
        "root"
        "anthony"
      ];

    };

  flake.homeModules.base-desktop = {

    services = {

    };
    imports = [
      self.homeModules.base
    ];

  };
}
