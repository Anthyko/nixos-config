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
    lf
    fd
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
    (pkgs.lutris.override {
  # Intercept buildFHSEnv to modify target packages
  buildFHSEnv = args: pkgs.buildFHSEnv (args // {
    multiPkgs = envPkgs:
      let
        # Fetch original package list
        originalPkgs = args.multiPkgs envPkgs;

        # Disable tests for openldap
        customLdap = envPkgs.openldap.overrideAttrs (_: { doCheck = false; });
      in
      # Replace broken openldap with the custom one
      builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
  });
})
    r2modman
    usbutils
    gnupg
    mumble
    python3
    poetry

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
