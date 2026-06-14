{ self, ... }:
{
  # cli apps shared among all the home-manager base config
  flake.homeModules.cli-apps =
    { pkgs, ... }:
    {
      imports = [
        self.homeModules.shell
        self.homeModules.text-editor
        self.homeModules.terminal-file-manager
      ];
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 15d --keep 3";
      };
      programs.git = {
        enable = true;
        settings.user = {
          email = "16465475+dat-Antho@users.noreply.github.com";
          name = "anthony";
        };
      };
      services.ssh-agent.enable = false;
      home.packages = with pkgs; [
        fzf
        gh
        gitflow
        htop
        ifuse
        lazygit
        tldr
        wget
        unzip
        zip
        gnupg
        rclone
        dig
        exfat
      ];
    };

}
