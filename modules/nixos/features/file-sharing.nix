{
  ...
}:
{
  flake.nixosModules.file-sharing = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      qbittorrent
    ];
  };

}
