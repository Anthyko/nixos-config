{
  config,
  pkgs,
  ...
}:
{
  environment.etc = {
    # Defines a filter that detects URL probing by reading the Nginx access log
    "fail2ban/filter.d/nginx-url-probe.local".text = pkgs.lib.mkDefault (
      pkgs.lib.mkAfter ''
        [Definition]
        failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
      ''
    );
  };
  services.fail2ban = {

    enable = true;

    bantime = "10m";

    banaction = "iptables-multiport";

    maxretry = 3;

    bantime-increment = {
      enable = true;
      factor = "2";
      formula = "bantime * (factor ** (attempts - 1))";
      maxtime = "2h";
    };

    jails = {
      sshd.settings = {
        enabled = true;
        findtime = "10m";
      };
      nginx-url-probe.settings = {
        enabled = true;
        filter = "nginx-url-probe";
        logpath = "/var/log/nginx/access.log";
        action = ''
          %(action_)s[blocktype=DROP]
                           ntfy'';
        maxretry = 5;
        findtime = 600;
      };
      recidive.settings = {
        enabled = true;
        logpath = "/var/log/fail2ban.log";
        bantime = "7d";
        findtime = "2d";
        maxretry = 5;
      };

    };
  };
}
