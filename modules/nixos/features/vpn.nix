{
  ...
}:
{

  flake.nixosModules.vpn = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      proton-vpn
    ];
  };

}
