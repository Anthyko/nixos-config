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
  }; 
}
