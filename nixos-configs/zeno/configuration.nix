# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  options,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/nvidia.nix
    ./modules/steam.nix
    ./modules/audio.nix
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/nvme0n1p1";
  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;
  hardware.keyboard.qmk.enable = true;
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
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
  # FLATPAK
  services.flatpak.enable = true;

  # SELFHOSTED-AI
  #environment.systemPackages = [
  # (pkgs.ollama.override {
  #   acceleration = "cuda";
  # })
  #pkgs.open-webui
  #];
  services.open-webui.enable = false; # should decide what to do with that
  # RANDOM PROGRAMS
  programs.localsend.enable = true; # airdrop alternative, needs to be here for firewall autoconfig
  programs.partition-manager.enable = true;
  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "intl";
  services.xserver.xkb.options = "compose:ralt";
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.anthony = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "test";
    packages = with pkgs; [
      firefox
      tree
      protonup-ng
      keepassxc
      steam-run
    ];
  };
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
  programs.zsh.enable = true;
  users.users.anthony.shell = pkgs.zsh;

  networking.hostName = "zeno";

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
