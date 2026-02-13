{ config
, pkgs
, ...
}: {
  services.murmur = {
    enable = true;
    dataDir = "/var/lib/teamspeak3-server";
    openFirewall = true;
  };
}
