_: {
  flake.nixosModules.x-server = _: {
    services.xserver.enable = true;

  };
}
