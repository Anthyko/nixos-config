{ config
, pkgs
, ...
}: {
  sops.secrets."murmur/env" = {
    sopsFile = ../../../secrets/murmur.env;
    format = "dotenv";
    owner = "murmur";
    group = "murmur";
    mode = "0400";
  };
  services.murmur = {
    enable = true;
    environmentFile = config.sops.secrets."murmur/env".path;
    openFirewall = true;
    password = "$MURMURD_PASSWORD";
  };
}
