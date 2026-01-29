{ username ? "anthony"
, extraAliases ? { }
,
}:

{ config
, lib
, pkgs
, ...
}:

let
  commonAliases = import ./aliases.nix {
    inherit username;
    extra = extraAliases;
  };
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    completionInit = "autoload -Uz compinit && compinit -C";
    initContent = lib.mkBefore ''
      export PATH="$HOME/bin:$PATH"
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
    '';

    shellAliases = commonAliases;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "MichaelAquilina/zsh-you-should-use"; }
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
}
