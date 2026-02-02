{ ... }:
{
  # ------------------------------------------------------------
  # aliases factory
  #
  # Purpose:
  #   Generate a merged alias set based on a username
  #   and an optional extra attribute set.
  #
  # Usage:
  #   inputs.self.factory.aliases {
  #     username = "anthony";
  #     extra = { ll = "ls -lah"; };
  #   }
  # ------------------------------------------------------------

  config.flake.factory.shell-aliases =
    { username, extra ? { } }:
    let
      common = {
        ll = "ls -alh";
        gs = "git status";

        nix-clean =
          "nix-collect-garbage -d && nix store optimise && nix-store --verify --check-contents --repair";

        nrb = "nh os boot . -- --accept-flake-config";
        nrs = "nh os switch . -- --accept-flake-config";

        g = "lazygit";
        nfmt = "nix run .#formatter.x86_64-linux -- .";
        f = "fcd";
        blk = "lsblk -o NAME,SIZE,MODEL,MOUNTPOINT";
      };
    in
    common // extra;
}
