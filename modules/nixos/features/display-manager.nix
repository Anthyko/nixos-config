{
  ...
}:
{

  flake.nixosModules.display-manager = _: {

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = false;
    };
  };

}
