{ self, system, ... }:

{
  # Desktop user config
  flake.homeModules.anthony-module =
    { pkgs, ... }:
    {
      imports = [
        self.homeModules.base-desktop
        self.homeModules.python
      ];
      home.username = system.users.main;
      home.homeDirectory = "/home/${system.users.main}";
      home.stateVersion = "24.05";
      home.sessionVariables = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };
      programs.zsh.shellAliases = {
        kde-fix-icons = "sed -i 's/file:\/\/\/nix\/store\/[^\/]*\/share\/applications\//applications:/gi' ~/.config/plasma-org.kde.plasma.desktop-appletsrc && systemctl restart --user plasma-plasmashell";
        ghb = "gh workflow run Build-configs";
        ghbl = "gh run list --workflow build.yml";
        ghbv = "gh run view $(gh run list --workflow build.yml -L 1 --json databaseId,conclusion,status --jq '[.[] | select(.conclusion == \"failure\" or .conclusion == \"success\" or .status == \"in_progress\")] | .[].databaseId')";
        nixos-repo = "xdg-open https://github.com/Anthyko/nixos-config";
        noctalia-json = "nix run nixpkgs#noctalia-shell ipc call state all > ./modules/packages/noctalia.json";
      };
    };
}
