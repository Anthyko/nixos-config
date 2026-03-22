{ inputs, self, ... }: {
  flake.nixosConfigurations.aurele = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      self.nixosModules.base
      self.nixosModules.base-desktop
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.aurele-module
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "";

        home-manager.sharedModules = [
          self.homeModules.base
          inputs.nixvim.homeModules.nixvim
          self.homeModules.base-desktop
          self.homeModules.multimedia-player
        ];

        home-manager.extraSpecialArgs = {
          inherit inputs self;
        };

        home-manager.users.anthony = import ../../../home-manager/aurele/home.nix;

        nix.settings.trusted-users = [
          "root"
          "anthony"
        ];
      }
    ];
  };

  flake.nixosModules.aurele-module = { lib, pkgs, ... }: {
    imports = [
      ./_modules/openssh.nix
      ../../../nixos-configs/aurele/hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    services.throttled.enable = lib.mkDefault true;

    networking.hostName = "aurele";
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.printing.enable = true;

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };

    fonts.packages = [
      pkgs.nerd-fonts.jetbrains-mono
    ];

    programs.ssh.startAgent = lib.mkForce false;
    services.xserver.xkb = {
      layout = "fr";
      variant = "";
    };
    console.keyMap = "fr";

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    programs.localsend.enable = true;

    users.users.anthony = {
      isNormalUser = true;
      description = "Anthony";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        firefox
        keepassxc
      ];
      shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
    programs.firefox.enable = true;

    system.stateVersion = "25.05";
  };
}
