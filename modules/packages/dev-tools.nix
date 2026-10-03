{ self, ... }:

{
  perSystem = { pkgs, ... }: {
    packages.dev-tools = pkgs.buildEnv {
      name = "dev-tools";

      paths = with pkgs; [
        jq
        k9s
        gitflow
        zellij
        lazygit
        wget
        self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
        self.packages.${pkgs.stdenv.hostPlatform.system}.zsh
      ];
    };
  };
}
