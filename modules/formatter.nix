{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
  ];
  perSystem =
    { config, pkgs, ... }:
    {
      pre-commit.settings.hooks = {
        nixfmt.enable = true;
        deadnix.enable = true;
        # statix.enable = true;

        check-merge-conflicts.enable = true;
        detect-private-keys.enable = true;
        end-of-file-fixer.enable = true;
        trim-trailing-whitespace.enable = true;
      };

      devShells.default = pkgs.mkShell {
        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
}
