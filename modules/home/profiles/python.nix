{ ... }:
{
  #shared module for all the home configs
  flake.homeModules.python =
    { pkgs, ... }:
    {

      home.packages = with pkgs; [
        python3
        poetry
      ];
    };

}
