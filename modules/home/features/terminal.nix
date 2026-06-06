{
  lib,
  ...
}:
{
  flake.homeModules.terminal = {

    programs.foot = {
      enable = true;
      settings = {
        main = {
          term = "foot";
          font = lib.mkForce "JetBrainsMono Nerd Font:size=12";
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
