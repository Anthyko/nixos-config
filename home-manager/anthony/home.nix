{ config
, pkgs
, ...
}:
let common = import ../common/programs/common-pkgs.nix pkgs;
in
{
  home.username = "anthony";
  home.homeDirectory = "/home/anthony";
  home.stateVersion = "24.05";
  home.packages = common ++ (with pkgs; [
    htop
    filezilla
    obsidian
    thunderbird
    wget
    exfat
    rclone
    vial
    neofetch
    lf
    fd
    calibre
    easyeffects
    dig
    libreoffice-still
    gh
    qFlipper
    protonup-qt
    # -- useful to plug phone and get the photos
    ifuse
    libimobiledevice
    # --
    lutris
    r2modman
    usbutils
    gnupg
    mumble

  ]);

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };


  stylix.targets.kitty.enable = false;
  stylix.targets.nixvim.enable = false;
  imports = [
    ./programs
    ../common/programs/git.nix
    ../common/programs/zoxide.nix
  ];
}
