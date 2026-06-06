{ inputs, self, ... }:
{
  flake.homeModules.text-editor =
    { pkgs, ... }:
    {
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      home.packages = [ self.packages.${pkgs.system}.nvim ];
    };
  perSystem =
    { system, ... }:
    {
      packages.nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
        module = {
          imports = [ ./_editor/nixvim.nix ];
          nixpkgs.source = inputs.nixpkgs;
        };
      };
    };
}
