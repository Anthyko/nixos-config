{
  lib,
  ...
}:
{
  flake.homeModules.shell =
    { config, ... }:
    {

      # shared aliases
      home.shellAliases = {
        ll = "ls -alh";
        gs = "git status";
        #  update = "nix flake update && home-manager switch --flake ~/.config/nix#${username}";
        nix-clean = "nix-collect-garbage -d && nix store optimise && nix-store --verify --check-contents --repair";
        nrb = "nh os boot . -- --accept-flake-config";
        nrs = "nh os switch . -- --accept-flake-config";
        clean = "nh clean all --keep 3";
        g = "lazygit";
        blk = "lsblk -o NAME,SIZE,MODEL,MOUNTPOINT";
        lsprs = "export PRS=($(gh pr list --json number -q '.[].number')) && for i in $PRS;do gh pr view $i;done";
        mprs = "lsprs && for i in $PRS;do sleep 1 && gh pr merge -d -r $i;done";
        j = "jobs -l";
        f = "fg";
        b = "bg";
        cjob = "kill -CONT %1";
        kjob = "kill %1";
      };
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        defaultKeymap = "viins";
        completionInit = "autoload -Uz compinit && compinit -C";
        initContent = lib.mkBefore ''
                export PATH="$HOME/bin:$PATH"
                export ZVM_SYSTEM_CLIPBOARD_ENABLED=true
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
                add_subtitles() {
            if [ "$#" -ne 2 ]; then
              echo "Usage: add_subtitles <video> <subtitles.srt>"
              return 1
            fi

            local video="$1"
            local subs="$2"
            local output="''${video%.*}_with_subs.mkv"

            if [ ! -f "$video" ]; then
              echo "Error: video file not found: $video"
              return 1
            fi

            if [ ! -f "$subs" ]; then
              echo "Error: subtitle file not found: $subs"
              return 1
            fi

            ffmpeg \
              -i "$video" \
              -i "$subs" \
              -map 0 \
              -map 1:0 \
              -c copy \
              -metadata:s:s:0 language=fra \
              -metadata:s:s:0 title="French" \
              "$output"

            if [ $? -eq 0 ]; then
              echo "File created: $output"
            else
              echo "Error: ffmpeg failed"
              return 1
            fi
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
            { name = "zsh-users/zsh-syntax-highlighting"; }
          ];
        };
      };
      programs.zoxide = {
        enable = true;
      };
    };
}
