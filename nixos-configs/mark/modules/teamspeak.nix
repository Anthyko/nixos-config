{
  config,
  pkgs,
  ...
}:
{
  services.teamspeak3 = {
    enable = true;
    dataDir = "/var/lib/teamspeak3-server";
    openFirewall = true;
  };
}
