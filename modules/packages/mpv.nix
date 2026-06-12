{ inputs, self, ... }:
{
  flake.homeModules.multimedia-player =
    { pkgs, ... }:
    {
      home.packages = [ self.packages.${pkgs.system}.mpv ];
    };
  perSystem =
    { pkgs, ... }:
    {

      packages.mpv = inputs.wrapper-modules.wrappers.mpv.wrap {
        inherit pkgs;
        script = {
          uosc = {
            path = pkgs.mpvScripts.uosc;
          };
          sponsorblockuosc = {
            path = pkgs.mpvScripts.sponsorblock;
          };

        };
      };
    };
}
