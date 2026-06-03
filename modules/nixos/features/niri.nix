{
  self,
  ...
}:
{

  flake.nixosModules.display-manager = _: {

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = false;
    };
  };
  flake.nixosModules.niri =
    { ... }:
    {

      imports = [
        self.nixosModules.display-manager
      ];
      security.polkit.enable = true; # polkit
      services.gnome.gnome-keyring.enable = true; # secret service
      programs.niri.enable = true;
      programs.niri.useNautilus = true;
      programs.xwayland.enable = true;
    };

}
