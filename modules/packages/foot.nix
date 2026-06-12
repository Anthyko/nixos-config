{ inputs, self, ... }:
{
  flake.homeModules.terminal =
    { pkgs, ... }:
    {
      home.packages = [ self.packages.${pkgs.system}.foot ];
    };
  perSystem =
    { pkgs, ... }:
    {

      packages.foot = inputs.wrapper-modules.wrappers.foot.wrap {
        inherit pkgs;
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
    };
}
