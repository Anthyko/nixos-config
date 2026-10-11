{
  config,
  ...
}:
{

  sops.secrets."searx/env" = {
    sopsFile = ../../../../secrets/mark/searx.env;
    format = "dotenv";
    owner = "searx";
    group = "searx";
    mode = "0400";
  };

  services.searx = {
    enable = true;
    environmentFile = config.sops.secrets."searx/env".path;
    settings = {
      server = {
        bind_address = "127.0.0.1";
        port = 8081;
        secret_key = "$SEARXNG_SECRET";
      };

      general = {
        debug = false;
        instance_name = "SearXNG Instance";
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
        enable_metrics = false;
      };

      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "Unit converter plugin"
        "Tracker URL remover"
      ];

    };
  };
  # I could not make the services.tailscale module serve this.
  # I'll use this for now
  systemd.services.tailscale-search = {
    description = "Tailscale Serve search";
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${config.services.tailscale.package}/bin/tailscale serve --service=svc:search http://127.0.0.1:8081";
    };
  };
}
