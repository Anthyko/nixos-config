{ config
, pkgs
, ...
}:
let
 tailscale_domain = "mark.tailf9979f.ts.net";
  tailscale_ip="100.118.197.94";
  tailscale_cert_directory = "/var/lib/tailscale/auto-certs";
in
{

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
    secret_key = "$SEARXNG_SECRET";
  };

    };
# setup reverse proxy

  # services.nginx = {
  #   enable = true;
  #   recommendedProxySettings = true;
  #   recommendedTlsSettings = true;
  #
  #   virtualHosts."${tailscale_domain}" = {
  #     listen = [
  #       { addr = tailscale_ip; port = 443; ssl = true; }
  #     ];
  #
  #   onlySSL = true;
  #     sslCertificate = "${tailscale_cert_directory}/${tailscale_domain}.crt";
  #     sslCertificateKey = "${tailscale_cert_directory}/${tailscale_domain}.key";
  #
  #     locations."/search" = {
  #       proxyPass = "http://127.0.0.1:8081";
  #       proxyWebsockets = true;
  #     };
  #   };
  # };
  #
  # setup permission to allow nginx to read certificates
  systemd.services.tailscale-cert-searx = {

    description = "Fetch/renew Tailscale TLS cert for nginx";
    after = [ "tailscaled.service" "network-online.target" ];
    wants = [ "network-online.target" ];

    before = [ "nginx.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = { Type = "oneshot"; UMask = "0077"; };
    script = ''
      install -d -m 0750 -o nginx -g nginx ${tailscale_cert_directory}

      ${pkgs.tailscale}/bin/tailscale cert \
        --cert-file ${tailscale_cert_directory}/${tailscale_domain}.crt \
        --key-file  ${tailscale_cert_directory}/${tailscale_domain}.key \
        ${tailscale_domain}

      chown nginx:nginx ${tailscale_cert_directory}/${tailscale_domain}.crt ${tailscale_cert_directory}/${tailscale_domain}.key
      chmod 0640 ${tailscale_cert_directory}/${tailscale_domain}.crt
      chmod 0640 ${tailscale_cert_directory}/${tailscale_domain}.key

      ${pkgs.systemd}/bin/systemctl reload nginx
    '';
  };

  ## to refresh the cert
  systemd.timers.tailscale-cert-searx = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "2h";
      Persistent = true;
    };
  };

}
