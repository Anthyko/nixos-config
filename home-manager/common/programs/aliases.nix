#used to share aliases, return all the common aliases merged with the "extra"
{ username
, extra ? { }
,
}:

let
  common = {
    ll = "ls -alh";
    gs = "git status";
    #  update = "nix flake update && home-manager switch --flake ~/.config/nix#${username}";
    nix-clean = "nix-collect-garbage -d && nix store optimise && nix-store --verify --check-contents --repair";
    nrb = "nh os boot . -- --accept-flake-config";
    nrs = "nh os switch . -- --accept-flake-config";
    g = "lazygit";
    nfmt = "nix run .#formatter.x86_64-linux -- .";
    f = "fcd";
    blk = "lsblk -o NAME,SIZE,MODEL,MOUNTPOINT";
    lsprs = "export PRS=($(gh pr list --json number -q '.[].number')) && for i in $PRS;do gh pr view $i;done";
    mprs = "for i in $PRS;do gh pr merge -d -r $i;done";
  };

in
common // extra
