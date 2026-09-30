{ self, system, ... }:
{
  flake.nixosModules.shell = { pkgs, ... }: {

    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.zsh
    ];
    environment.shells = [
    ];
    environment.localBinInPath = true;
    users.users.${system.users.main}.shell = self.packages.${pkgs.stdenv.hostPlatform.system}.zsh;
  };
  flake.wrappers.zsh =
    { pkgs, wlib, ... }:

    {
      imports = [
        wlib.wrapperModules.zsh
      ];

      zshAliases = {
        ll = "ls -alh";
        gs = "git status";

        nix-clean = "nix-collect-garbage -d && nix store optimise && nix-store --verify --check-contents --repair";

        nrb = "nh os boot . -- --accept-flake-config";
        nrs = "nh os switch . -- --accept-flake-config";
        clean = "nh clean all --keep 3";

        g = "lazygit";
        blk = "lsblk -o NAME,SIZE,MODEL,MOUNTPOINT";

        lsprs = "export PRS=($(gh pr list --json number -q '.[].number')) && for i in $PRS; do gh pr view $i; done";

        mprs = "lsprs && for i in $PRS; do sleep 1 && gh pr merge -d -r $i; done";

        j = "jobs -l";
        f = "fg";
        b = "bg";
        cjob = "kill -CONT %1";
        kjob = "kill %1";
      };

      runtimePkgs = with pkgs; [
        # Tools used by the shell
        eza
        fzf
        zoxide

        # Zsh plugins
        zsh-autosuggestions
        zsh-syntax-highlighting
        zsh-vi-mode
        zsh-you-should-use
        pure-prompt
      ];

      zshrc.content = ''
        export PATH="$HOME/bin:$PATH"

        export ZVM_SYSTEM_CLIPBOARD_ENABLED=true

        # Completion
        autoload -Uz compinit
        compinit -C

        # zsh-autosuggestions
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

        # zsh-you-should-use
        source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
        # zsh-vi-mode
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        # Pure prompt
        # adding the theme to fpath
        fpath=(${pkgs.pure-prompt}/share/zsh/site-functions $fpath)
        autoload -U promptinit
        promptinit
        prompt pure

        # Initialize zoxide
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"

        fcd() {
          local dir
          dir=$(fd . ~/ /mnt -t d --hidden --exclude .git 2>/dev/null \
            | fzf --preview 'eza -T --color=always {} | head -40') || return
          cd "$dir"
        }

        nixwiki() {
          xdg-open \
            "https://wiki.nixos.org/w/index.php?search=$1" \
            >/dev/null 2>&1
        }

        nixo() {
          xdg-open \
            "https://search.nixos.org/options?channel=unstable&include_modular_service_options=1&include_nixos_options=1&query=$1" \
            >/dev/null 2>&1
        }

        nixp() {
          xdg-open \
            "https://search.nixos.org/packages?channel=unstable&include_modular_service_options=1&include_nixos_options=1&query=$1" \
            >/dev/null 2>&1
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

        # Must be loaded after other plugins.
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        # Optional local configuration.
        if [[ -r "$HOME/.zshrc_local" ]]; then
          source "$HOME/.zshrc_local"
        fi
      '';
    };
}
