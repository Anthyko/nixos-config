{
  ...
}:
{

  flake.nixosModules.password-manager = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      keepassxc
    ];
  };

}
