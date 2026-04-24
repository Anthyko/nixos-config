{ inputs, self, ... }: {

  flake.nixosConfigurations.mark = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      self.nixosModules.base
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.mark-module
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "";

        home-manager.sharedModules = [
          self.homeModules.base
          inputs.nixvim.homeModules.nixvim
        ];

        home-manager.extraSpecialArgs = {
          inherit inputs self;
        };

        home-manager.users.anthony = import ../../../home-manager/mark/home.nix;

        nix.settings.trusted-users = [
          "root"
          "anthony"
        ];
      }
    ];
  };

  flake.nixosModules.mark-module = { modulesPath, pkgs, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/profiles/qemu-guest.nix")
      ./_modules/fail2ban.nix
      ./_modules/murmur.nix
      ./_modules/openssh.nix
      ./_modules/users.nix
      ./_modules/radicale.nix
      ./_modules/nginx.nix
      ./_modules/search-engine.nix
      ./_modules/music-server.nix
      ./../../../hardware/mark/disk-config.nix
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

    networking.firewall.allowedTCPPorts = [ 80 443 ];
    networking.hostName = "mark";
    networking.firewall.enable = true;

    system.autoUpgrade = {
      enable = true;
      flake = "/home/anthony/git/nixos-config";
      operation = "switch";
      dates = "09:00";
      flags = [ "--accept-flake-config" ];
      allowReboot = true;
    };

    systemd.services.update-nixos-config = {
      path = [ pkgs.git ];
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
  };
}
