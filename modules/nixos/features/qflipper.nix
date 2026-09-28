{
  ...
}:
{

  flake.nixosModules.qflipper = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      qFlipper
    ];
  };

}
