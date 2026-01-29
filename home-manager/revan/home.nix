{ config
, pkgs
, ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ahengy";
  home.homeDirectory = "/home/ahengy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    python312
    python312Packages.pip
    python312Packages.nox
    python312Packages.virtualenv
    python312Packages.mypy
    (poetry.override { python3 = python312; })
    gitflow
    tldr
    lazygit
    nh
    zellij
    k9s
    stdenv.cc.cc.lib
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };
  imports = [
    (import ../common/programs/zsh-base.nix {
      extraAliases = { };
    })
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
