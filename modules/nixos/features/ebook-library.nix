{
  ...
}:
{

  flake.nixosModules.ebook-library = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      calibre
    ];
  };

}
