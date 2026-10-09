{ self, ... }:
{
  flake.nixosModules.terminal-file-manager =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.yazi;
      };
    };
  flake.wrappers.yazi =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.yazi ];
      settings = {
        keymap.mgr = {
          prepend_keymap = [
            {
              on = "!";
              for = "unix";
              run = "shell \"$SHELL\" --block";
              desc = "Open $SHELL here";
            }
          ];
        };

      };
    };
}
