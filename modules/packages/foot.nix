{ self, ... }:
{
  flake.homeModules.terminal =
    { pkgs, ... }:
    {
      home.packages = [ self.packages.${pkgs.system}.foot ];
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
