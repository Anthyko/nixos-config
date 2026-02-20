{ config
, pkgs
, ...
}: {

  sops.secrets."searx/env" = {
    sopsFile = ../../../secrets/searx.env;
    format = "dotenv";
    owner = "searx";
    group = "searx";
    mode = "0400";
  };

  services.searx = {
  enable = true;
  environmentFile = config.sops.secrets."searx/env".path;
  settings.server = {
    bind_address = "127.0.0.1";
    port = 8081;
    # WARNING: setting secret_key here might expose it to the nix cache
    # see below for the sops or environment file instructions to prevent this
    secret_key = "$SEARXNG_SECRET";
  };
};
}
