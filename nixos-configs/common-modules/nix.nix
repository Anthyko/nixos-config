{ config
, pkgs
, ...
}: {
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  nix.optimise.automatic = true;
  # keeps the last 5 generations in grub
  boot.loader.systemd-boot.configurationLimit = 5;
  # garbage collection schedule
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };
  nix.optimise.dates = [ "12:00" ];
}
