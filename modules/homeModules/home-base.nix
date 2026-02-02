{ inputs, ... }:
{
  # Factory to create homeModules with home.nix values
  config.flake.factory.home-base =
    { username ? "anthony"
    , homeDirectory ? "/home/${username}"
    ,
    }:
    { config
    , lib
    , pkgs
    , ...
    }: {
      home.username = username;
      home.homeDirectory = homeDirectory;
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      home.stateVersion = "24.11";
    };

}
