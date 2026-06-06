{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
        inherit pkgs; # THIS PART IS VERY IMPORTAINT, I FORGOT IT IN THE VIDEO!!!
        settings =
          (builtins.fromJSON
            # to save current noctalia config file run
            # $ nix run nixpkgs#noctalia-shell ipc call state all > ./modules/features/noctalia.json
            (builtins.readFile ./noctalia.json)
          ).settings;
      };
    };
}
