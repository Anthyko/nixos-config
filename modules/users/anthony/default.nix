{ self, ... }:
{
  flake.homeModules.anthony-module =
    { pkgs, ... }:
    {
      imports = [
        self.homeModules.base-desktop
        self.homeModules.python
        self.homeModules.newsboat
      ];
      home.username = "anthony";
      home.homeDirectory = "/home/anthony";
      home.stateVersion = "24.05";
      home.sessionVariables = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };
      home.packages = with pkgs; [
        qFlipper
        easyeffects
        protonup-qt
        protonup-ng
        libreoffice-still
        r2modman
        usbutils
        gnupg
      ];
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
