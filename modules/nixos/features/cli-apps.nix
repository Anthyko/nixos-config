{
  inputs,
  ...
}:
{

  flake.nixosModules.cli-apps = { pkgs, ... }: {

    imports = with inputs.self.nixosModules; [
      terminal-file-manager
    ];
    environment.systemPackages = with pkgs; [
      fzf
      gh
      gitflow
      htop
      lazygit
      tldr
      wget
      unzip
      zip
      gnupg
      dig
      exfat
      ffmpeg
      gnupg
      usbutils # lsusb
    ];
  };

}
