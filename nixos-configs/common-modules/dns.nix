{
  config,
  pkgs,
  lib,
  ...
}:
{

  networking.useHostResolvConf = false;

  networking.nameservers = [ "127.0.0.1" ];
  networking.networkmanager.dns = lib.mkForce "none";
  services.adguardhome = {
    enable = true;
    mutableSettings = false; # only declarative config hehe
    settings = {
      dns = {
        # REQUIRED: List of bootstrap DNS servers for DoH/DoT name resolution
        bootstrap_dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        upstream_dns = [
          "https://dns.cloudflare.com/dns-query"
          "https://dns.quad9.net/dns-query"
        ];
        upstream_mode = "parallel";
        cache_size = 4096;
        cache_ttl_min = 300;
        cache_ttl_max = 1800;
        cache_optimistic = true;
        enable_dnssec = true;

      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;

        parental_enabled = false; # Parental control-based DNS requests filtering.
        safe_search = {
          enabled = false; # Enforcing "Safe search" option for search engines, when possible.
        };
      };

      filters = [
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
          name = "StevenBlack";
        }
      ];
    };
  };
}
