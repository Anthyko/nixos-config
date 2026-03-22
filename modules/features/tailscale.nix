{ inputs
, lib
, ...
}:
{
  flake.nixosModules.tailscale = { pkgs, ... }: {
  services.tailscale.enable = true;
  services.tailscale.extraDaemonFlags = [ "--no-logs-no-support" ];

  };
}
