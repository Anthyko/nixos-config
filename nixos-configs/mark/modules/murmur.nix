{ config
, pkgs
, ...
}:
let
  domain = "vps.datantho.ovh";
  certDir = config.security.acme.certs.${domain}.directory;
in
{

  # Create a new group for nginx and murmur
  # This group is set has owner of the cert
  users.groups.certreaders = { };
  users.users.nginx.extraGroups = [ "certreaders" ];
  users.users.murmur.extraGroups = [ "certreaders" ];
  security.acme = {
    certs.${domain} = {
      group = "certreaders";
    };
  };

  # The cert is generated via http challenge, this is more simple this way
  services.nginx.virtualHosts.${domain} = {
    enableACME = true;
    forceSSL = true;
    # locations."/" = {
    #proxyPass = "http://127.0.0.1:3000";
    #};
  };
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

    sslCert = "${certDir}/fullchain.pem";
    sslKey = "${certDir}/key.pem";
    sslCa = "${certDir}/chain.pem";
  };
}
