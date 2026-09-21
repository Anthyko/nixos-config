{ ... }:
{
  #shared module for all the home configs
  flake.homeModules.python =
    { pkgs, ... }:
    {

      programs.uv = {
        enable = true;

        python = {
          versions = [
            "3.14"
            "3.13"
            "3.12"
            "3.11"
          ];
          default = [ "3.11" ];
          prune = true;
        };

      };
    };

}
