{ inputs, self, ... }:
{
  flake.nixosModules.text-editor =
    { pkgs, ... }:
    {
      environment.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
      ];
    };
  perSystem =
    { system, ... }:
    {
      packages.nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        module = {
          imports = [
            (inputs.import-tree ./_editor) # imports config and plugins
          ];
          nixpkgs.source = inputs.nixpkgs;

        };
      };
    };
}
