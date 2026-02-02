{
  config,
  pkgs,
  ...
}:
{
  services.radicale = {
    enable = true;

    # Minimal Radicale config; listens only on localhost
    settings = {
      server = {
        hosts = [ "127.0.0.1:5232" ];
      };

      auth = {
        type = "htpasswd";
        htpasswd_filename = "/etc/radicale/htpasswd";
        htpasswd_encryption = "bcrypt";
      };

    };
  };

}
