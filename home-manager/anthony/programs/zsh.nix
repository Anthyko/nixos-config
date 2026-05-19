{
  ...
}:
{
  imports = [ ../../common/programs/zsh-base.nix ];
  programs.zsh.shellAliases = {
    kde-fix-icons = "sed -i 's/file:\/\/\/nix\/store\/[^\/]*\/share\/applications\//applications:/gi' ~/.config/plasma-org.kde.plasma.desktop-appletsrc && systemctl restart --user plasma-plasmashell";
    ghb = "gh workflow run Build-configs";
    ghbl = "gh run list --workflow build.yml";
    ghbv = "gh run view $(gh run list --workflow build.yml -L 1 --json databaseId,conclusion,status --jq '[.[] | select(.conclusion == \"failure\" or .conclusion == \"success\" or .status == \"in_progress\")] | .[].databaseId')";
    nixos-repo = "xdg-open https://github.com/Anthyko/nixos-config";
  };
}
