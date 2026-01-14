{ modulesPath
, lib
, pkgs
, ...
}@args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./modules/fail2ban.nix
    ./modules/teamspeak.nix
    ./modules/openssh.nix
    ./modules/users.nix
    ./modules/radicale.nix
    ./modules/nginx.nix
    ./modules/woodpecker.nix
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
   environment.systemPackages = with pkgs; [ 
    git 
  ];
  ############################
  # Firewall
  ############################
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  networking.hostName = "mark";

  networking.firewall.enable = true;
  system.autoUpgrade = {
    enable = true;

    flake = "/home/anthony/git/nixos-config";

    operation = "boot";

    dates = "18:20";

    allowReboot = true;
  };
systemd.services.update-nixos-config = {
  description = "Update NixOS config repo (pull deployment)";
  serviceConfig = {
    Type = "oneshot";
    User = "root";
  };
  script = ''
    set -euo pipefail
    cd /home/anthony/git/nixos-config
    git fetch --prune origin
    git checkout -f origin/master
  '';
};

# pull git repo before building
systemd.services.nixos-upgrade = {
  after = [ "update-nixos-config.service" ];
  wants = [ "update-nixos-config.service" ];
};

  system.stateVersion = "24.05";
}
