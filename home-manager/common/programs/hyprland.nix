{
  config,
  pkgs,
  lib,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    systemd.enable = false;
    portalPackage = null;
    settings = {
      env = [
        "FILE_MANAGER,nautilus"
      ];
      "$mod" = "SUPER";
      general = {
        "col.active_border" = lib.mkForce "rgb(d79921)";
        gaps_in = 3;
        gaps_out = 5;
        border_size = 2;

      };
      decoration = {
        rounding = 10;
        blur.enabled = false;
        shadow.enabled = false;
      };
      input = {
        kb_layout = "us,fr";
        kb_variant = "intl,";
        kb_options = "grp:win_space_toggle";
      };
      misc = {
        enable_swallow = true;
        swallow_regex = "^(kitty|foot|alacritty|footclient)$";
      };
      animations = {
        enabled = false;
      };

      # Keybindings
      bind = [
        "$mod,Return, exec, foot"
        "$mod,T, exec, kitty"
        "$mod,B, exec, firefox"
        "$mod,E, exec, $FILE_MANAGER"
        "$mod,D, exec, wofi --show drun -D key_expand=Tab"
        "$mod,Q, killactive"
        "$mod,M, exit"
        "$mod,1, workspace, 1"
        "$mod,2, workspace, 2"
        "$mod,3, workspace, 3"
        "$mod SHIFT,R, exec, hyprctl, reload"
        "$mod SHIFT,1, movetoworkspace, 1"
        "$mod SHIFT,2, movetoworkspace, 2"
        "$mod SHIFT,3, movetoworkspace, 3"
        "$mod,H, movefocus, l"
        "$mod,L, movefocus, r"
        "$mod,K, movefocus, u"
        "$mod,J, movefocus, d"
        "$mod,V, togglesplit"
        "$mod,F, fullscreen"
        "$mod SHIFT,Space, togglefloating"
        "SUPER SHIFT,H, swapwindow, l"
        "SUPER SHIFT,L, swapwindow, r"
        "SUPER SHIFT,K, swapwindow, u"
        "SUPER SHIFT,J, swapwindow, d"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Autostart (Waybar, Mako)
      exec-once = [
        "waybar"
        "mako"
        "swww-daemon &"
        "swww img ~/git/nixos-config/home-manager/common/background3.png"
        "systemctl --user start hyprpolkitagent "
      ];
    };
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        # height = 36;

        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "custom/public-ip"
          "custom/gpu-temp"
          "temperature"
          "battery"
          "pulseaudio"
          "hyprland/language"
        ];
        "hyprland/language" = {
          format = "{short}";
          format-alt = "{short}";
        };
        clock = {
          format = "{:%d/%m - %H:%M}";
        };

        network = {
          # not enabled because there is a network tool in system tray
          #"format-wifi" = "  {essid} ({signalStrength}%)";
          "format-ethernet" = "Eth";
          "format-disconnected" = "󰤭  Offline";
          "on-click" = "nm-connection-editor";
        };

        battery = {
          format = "{icon}  {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        pulseaudio = {
          format = "  {volume}%";
          format-muted = "🔇 Muted";
          scroll-step = 5; # Volume step with mouse wheel
          on-click = "pavucontrol"; # Open gui
        };

        tray = {
          icon-size = 16;
          spacing = 10;
        };

        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
          format = "CPU: {temperatureC}°C";
          critical-threshold = 90;
          interval = 5;
        };
        "custom/gpu-temp" = {
          exec = ''
            temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)

            if [ -n "$temp" ] && [ "$temp" != "N/A" ]; then
              echo "GPU: $temp°C"
            else
              echo ""
            fi
          '';
          interval = 5;
          return-type = "text";
        };

        "custom/public-ip" = {
          exec = "curl -L -4 iprs.fly.dev || echo N/A";
          interval = 5;
          return-type = "text";
          format = "🌍 {}";
        };
      }
    ];
    style = ''
      @define-color bg-main        #282828;
      @define-color bg-alt         #3c3836;
      @define-color bg-inactive    #504945;
      @define-color bg-focus       #665c54;

      @define-color fg-normal      #ebdbb2;
      @define-color fg-muted       #a89984;
      @define-color fg-warning     #fabd2f;
      @define-color fg-critical    #fb4934;
      @define-color fg-accent      #d79921;
      @define-color fg-success     #98971a;
      @define-color fg-link        #83a598;

      @define-color red            #cc241d;
      @define-color green          #98971a;
      @define-color yellow         #d79921;
      @define-color orange         #fe8019;
      @define-color blue           #458588;
      @define-color purple         #b16286;
      @define-color aqua           #8ec07c;

      * {
        font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font";
        font-size: 14px;
        font-weight: bold;
        border: none;
        margin: 0;
        padding: 0;
      }

      window#waybar {
        background-color: transparent;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      /* Modules containers */
      .modules-left,
      .modules-center,
      .modules-right {
        margin: 2px 4px;
        background-color: transparent;
      }

      /* Workspaces */
      #workspaces button {
        padding: 2px 4px;
        margin: 2px;
        color: @fg-muted;
        background: transparent;
        border-radius: 6px;
      }

      #workspaces button.focused {
        background: @bg-focus;
        color: @fg-accent;
      }

      #workspaces button.urgent {
        background: @fg-critical;
        color: @bg-main;
      }

      #workspaces button.active {
        background: @bg-focus;
        color: @fg-normal;
      }

      /* Generic module style */
      #clock,
      #cpu,
      #memory,
      #temperature,
      #disk,
      #battery,
      #network,
      #pulseaudio,
      #custom-microphone,
      #custom-public-ip,
      #custom-gpu-temp,
      #tray {
        padding: 2px 4px;
        margin: 0 2px;
        border-radius: 8px;
        background-color: @bg-inactive;
        color: @fg-normal;
      }

      /* Individual module tweaks */
      #clock {
        color: @fg-accent;
      }

      #cpu,
      #memory {
        color: @fg-normal;
      }

      #temperature {
        color: @fg-normal;
      }

      #disk {
        color: @aqua;
      }

      #battery {
        color: @fg-success;
      }

      #battery.warning:not(.charging) {
        color: @fg-warning;
      }

      #battery.critical:not(.charging) {
        color: @fg-critical;
      }

      #pulseaudio {
        color: @fg-normal;
      }

      #custom-public-ip {
        color: @fg-link;
      }

      #network {
        color: @aqua;
      }

      #network.disconnected {
        color: @fg-muted;
      }

      /* Tray icons */
      #tray {
        background-color: @bg-inactive;
        margin: 0 3px;
      }

      #custom-notification {
        color: @yellow;
        padding-right: 8px;
      }
    '';

  };
  # };
  # Add rice packages
  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita"; # Ou "Breeze", "Bibata-Modern-Ice", "Capitaine Cursors", etc.
    package = pkgs.adwaita-icon-theme;
    size = 50;
  };
  home.packages = with pkgs; [
    kitty # Terminal
    grim
    slurp # Screenshots
    swappy # Annotate screenshots
    # should i keep these ?
    swww # background manager
    wofi # launcher
    adwaita-icon-theme
    hyprpolkitagent # allow apps to ask credentials
    pavucontrol # audio control
    pamixer # used to detect if mic is on
    pipewire # audio stuff
    pulseaudio # audio stuff
    foot # terminal
    libmtp # to connect to android phone
    nautilus # file manager
    networkmanagerapplet # network manager

  ];

  services.gammastep = {
    enable = true;
    latitude = "43.580799";
    longitude = "7.123900";
    temperature.day = 5200;
    temperature.night = 3600;
    tray = true;
  };

  # set nautilus as default file manager
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
    "application/x-gnome-saved-search" = [ "org.gnome.Nautilus.desktop" ];
  };

  # set default file browser
  services.mako = {
    # Notifications
    enable = true;
    settings = {

      default-timeout = 5000; # milliseconds
    };
  };
}
