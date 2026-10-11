{
  config,
  network,
  ...
}:
let
  vhost = "voice.${network.domains.vps}";
in
{

  # Create a new group for nginx and murmur
  # This group is set has owner of the cert
  users = {

    groups.certreaders = { };
    users = {

      nginx.extraGroups = [ "certreaders" ];
      murmur.extraGroups = [ "certreaders" ];
    };
  };

  security.acme = {
    certs.${vhost} = {

      group = "certreaders";
      reloadServices = [
        "murmur.services"
      ];
    };
  };
  # The cert is generated via http challenge, this is more simple this way
  services.nginx.virtualHosts.${vhost} = {
    enableACME = true;
    forceSSL = true;
    #};
  };
  sops.secrets."murmur/env" = {
    sopsFile = ../../../../secrets/mark/murmur.env;
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

    tls = {
      useACMEHost = vhost;
    };
  };
}
