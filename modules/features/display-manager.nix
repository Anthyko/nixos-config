{ inputs
, lib
, ...
}:
{
  flake.nixosModules.display-manager = { pkgs, ... }: {
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = false;
  };
}
