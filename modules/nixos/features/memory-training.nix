{
  ...
}:
{

  flake.nixosModules.memory-training = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      anki
    ];
  };

}
