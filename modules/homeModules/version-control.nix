{ inputs, ... }:
{
  flake.homeModules.version-control =
    { pkgs, ... }:
    {
      programs.git.settings = {
        enable = true;
        userEmail = "16465475+dat-Antho@users.noreply.github.com";
        userName = "anthony";
      };
    };
}
