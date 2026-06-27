{ self, ... }:
{
  flake.homeModules.multimedia-player =
    { pkgs, ... }:
    {
      home.packages = [ self.packages.${pkgs.system}.mpv ];
    };

  flake.wrappers.mpv =
    { wlib, pkgs, ... }:
    {
      imports = [ wlib.wrapperModules.mpv ];
      script = {
        uosc = {
          path = pkgs.mpvScripts.uosc;
        };
        sponsorblockuosc = {
          path = pkgs.mpvScripts.sponsorblock;
        };
      };
    };
}
