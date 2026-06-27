{ self, ... }:
{
  flake.homeModules.terminal-file-manager =
    { pkgs, ... }:
    {
      home.packages = [ self.packages.${pkgs.system}.yazi ];
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
