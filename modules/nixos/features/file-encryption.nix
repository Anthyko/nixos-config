{
  ...
}:
{

  flake.nixosModules.file-encryption = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      cryptomator
    ];
  };

}
