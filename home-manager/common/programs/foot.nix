{
  config,
  pkgs,
  lib,
  ...
}:
{
  stylix.targets.foot.enable = true;
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "foot";
        font = lib.mkForce "JetBrainsMono Nerd Font:size=12";
      };
      bell = {
        urgent = "no";
        notify = "no";
        visual = "no";
      };
    };
  };
}
