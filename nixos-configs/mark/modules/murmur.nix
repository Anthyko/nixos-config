{ config
, pkgs
, ...
}: {
  services.murmur = {
    enable = true;
    openFirewall = true;
  };
}
