{
  config,
  network,
  ...
}:
let
  vhost = "syncp.${network.domains.vps}";
in
{

  sops.secrets."syncplay" = {
    sopsFile = ../../../../secrets/mark/syncplay.yaml;
    format = "yaml";
    key = "password";
    mode = "0400";
  };
  services = {
    nginx = {

      virtualHosts.${vhost} = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
        };
      };
    };
    syncplay = {
      enable = true;

      extraArgs = [
        "--ipv4-only"
      ];

      port = 8999;
      chat = false;
      passwordFile = config.sops.secrets."syncplay".path;
      useACMEHost = vhost;
    };
  };

}
