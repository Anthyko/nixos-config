{
  ...
}:
{

  flake.nixosModules.version-control = { pkgs, ... }: {
    programs.git = {
      enable = true;

      config = {
        user = {
          name = "anthony";
          email = "16465475+dat-Antho@users.noreply.github.com";
        };
      };
    };
  };

}
