{
  config,
  network,
  ...
}:
let
  vhost = "cal.${network.domains.vps}";
in
{
  sops.secrets."radicale" = {
    sopsFile = ../../../../secrets/mark/radicale.yaml;
    format = "yaml";
    owner = "radicale";
    group = "radicale";
    key = "htpasswd";
    mode = "0400";
  };

  services = {
    nginx = {
      virtualHosts."${vhost}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:5232/";
            extraConfig = ''
              proxy_set_header X-Script-Name /radicale/;
              proxy_pass_header Authorization;
            '';
          };
        };
      };
    };

    radicale = {
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
  };
}
