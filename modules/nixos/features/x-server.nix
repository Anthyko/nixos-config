{
  ...
}:
{
  flake.nixosModules.x-server =
    { ... }:
    {
      services.xserver.enable = true;

    };
}
