{ config
, lib
, pkgs
, ...
}:
{
  imports = [ ./aliases.nix ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    completionInit = "autoload -Uz compinit && compinit -C";
    initContent = lib.mkBefore ''
      export PATH="$HOME/bin:$PATH"
      export ZVM_SYSTEM_CLIPBOARD_ENABLED=true
      zcompile ~/.zshrc
      fcd() {
        local dir
         dir=$(fd . ~/ /mnt -t d --hidden --exclude .git 2>/dev/null \
          | fzf --preview 'exa -T --color=always {} | head -40') || return
        cd "$dir"
      }
       # Load per-host/user overrides if present
       if [[ -r "$HOME/.zshrc_local" ]]; then
          source "$HOME/.zshrc_local"
        fi

      nixwiki() { #search in nixos wiki
        xdg-open "https://wiki.nixos.org/w/index.php?search=$1" >/dev/null 2>&1
      }
      nixo() { #search for nix options
        xdg-open "https://search.nixos.org/options?channel=unstable&include_modular_service_options=1&include_nixos_options=1&query=$1" >/dev/null 2>&1
      }
      nixp() { #search for nix packages
        xdg-open "https://search.nixos.org/packages?channel=unstable&include_modular_service_options=1&include_nixos_options=1&query=$1" >/dev/null 2>&1
      }
    '';


    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "MichaelAquilina/zsh-you-should-use"; }
        { name = "jeffreytse/zsh-vi-mode"; }
        {
          name = "mafredri/zsh-async";
          tags = [ "from:github" ];
        }
        {
          name = "sindresorhus/pure";
          tags = [
            "as:theme"
            "use:pure.zsh"
            "from:github"
          ];
        }
      ];
    };
  };
  programs.zoxide = {
    enable = true;
  };
}
