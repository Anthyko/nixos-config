{ self, ... }:
{
  flake.nixosModules.terminal = { pkgs, ... }: {

    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.foot
    ];
  };
  flake.wrappers.foot =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.foot ];

      settings = {
        main = {
          term = "foot";
          font = "JetBrainsMono Nerd Font:size=12";
        };

        csd = {
          preferred = "none";
        };

        bell = {
          urgent = "no";
          notify = "no";
          visual = "no";
        };
      };
    };
}
