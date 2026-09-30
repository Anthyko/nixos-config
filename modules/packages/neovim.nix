{ inputs, self, ... }:
{
  flake.homeModules.text-editor =
    { pkgs, ... }:
    {
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.nvim ];
    };
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
