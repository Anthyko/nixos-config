{ inputs, pkgs, ... }:
{
  flake.homeConfigurations.zeno = inputs.homeConfigurations.lib.homeManagerConfiguration {
    modules = [
      (inputs.self.factory.home-base { })
      inputs.self.homeModules.basic-common-desktop
    ];
    home.packages = (
      with pkgs;
      [
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
        wineWowPackages.stable
        teamspeak6-client
        lutris
        r2modman
        usbutils
        gnupg
      ]
    );

    disableStylixKitty = true;
    disableStylixNixvim = true;
    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
  };

}
