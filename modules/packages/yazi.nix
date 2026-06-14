{ inputs, self, ... }:
{
  flake.homeModules.terminal-file-manager =
    { pkgs, ... }:
    {
      home.packages = [ self.packages.${pkgs.system}.yazi ];
    };
  perSystem =
    { pkgs, ... }:
    {

      packages.yazi = inputs.wrapper-modules.wrappers.yazi.wrap {
        inherit pkgs;
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
    };
}
