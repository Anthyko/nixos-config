{
  config,
  pkgs,
  ...
}:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedTlsSettings = true;
    logError = "/var/log/nginx/error.log warn";
    virtualHosts."cal.datantho.ovh" = {
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
    # virtualHosts."ci.datantho.ovh" = {
    #   enableACME = true;
    #   forceSSL = true;
    #   locations."/" = { proxyPass = "http://127.0.0.1:3007"; };
    # };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "me@datantho.ovh";
  };

}
