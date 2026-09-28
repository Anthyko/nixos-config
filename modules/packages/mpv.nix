{ self, ... }:
{
  flake.nixosModules.multimedia-player = { pkgs, ... }: {

    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.mpv
    ];
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
