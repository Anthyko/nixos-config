{ config
, pkgs
, ...
}: {
  sops.secrets."radicale" = {
    sopsFile = ../../../secrets/radicale.yaml;
    format = "yaml";
    owner = "radicale";
    group = "radicale";
    key = "htpasswd";
    mode = "0400";
  };

  services.radicale = {
    enable = true;

    # Minimal Radicale config; listens only on localhost
    settings = {
      server = {
        hosts = [ "127.0.0.1:5232" ];
      };

      auth = {
        type = "htpasswd";
        htpasswd_filename = config.sops.secrets."radicale".path;
        htpasswd_encryption = "bcrypt";
      };

    };
  };


}
