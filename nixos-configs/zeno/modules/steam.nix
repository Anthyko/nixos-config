{
  config,
  pkgs,
  ...
}:
{
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.steam.gamescopeSession.enable = false;
  programs.steam.remotePlay.openFirewall = true;
  environment.systemPackages = with pkgs; [
    mangohud
  ];
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
