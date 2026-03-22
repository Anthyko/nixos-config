{ inputs
, lib
, ...
}:
{
  flake.nixosModules.x-server = { pkgs, ... }: {
    services.xserver.enable = true;

  };
}
