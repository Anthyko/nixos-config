{
  ...
}:
{

  flake.nixosModules.communication = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      thunderbird
      signal-desktop
      mumble
      discord
    ];
  };

}
