{
  self,
  ...
}:
{
  flake.homeModules.desktop-utils =
    { ... }:
    {

      imports = [
        self.homeModules.terminal
      ];

      programs = {
        swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
      };
      services = {
        swayidle.enable = true; # idle management daemon
        polkit-gnome.enable = true; # polkit
        gammastep = {
          enable = true;
          latitude = "43.580799";
          longitude = "7.123900";
          temperature.day = 5200;
          temperature.night = 3600;
          tray = true;
        };

      };

    };
}
