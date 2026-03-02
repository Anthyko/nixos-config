{ config, pkgs, ... }:

{
 
   programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        # height = 36;

        modules-left = [
          "niri/workspaces"
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
          "niri/language"
        ];
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
          format-icons = [ "" "" "" "" "" ];
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
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
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

        "niri/workspaces" = {
          current-only=true;
        };

      }
    ];
     style =
      ''
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
}
