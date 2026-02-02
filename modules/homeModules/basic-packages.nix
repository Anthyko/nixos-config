{ inputs, ... }:
{
  flake.homeModules.common-packages =
    { pkgs, ... }:
    {
      # all the common packages
      home.packages = with pkgs; [
        git
        nh
        lazygit
        tldr
        fzf
        nix-init
        fd
        exfat
      ];
    };
  flake.homeModules.basic-common-desktop =
    { pkgs, ... }:
    {
      imports = [
        inputs.self.homeModules.common-packages
      ];

      home.packages = with pkgs; [
        discord
        protonvpn-gui
        keepassxc
        signal-desktop
        ifuse
        libimobiledevice

        cryptomator
      ];

    };
}
