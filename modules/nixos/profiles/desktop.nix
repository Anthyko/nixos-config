{ inputs, ... }:
{

  flake.nixosModules.base-desktop = {
    imports =
      (with inputs.self.nixosModules; [
        base
        x-server
        niri
      ])
      ++ [
      ];

  };

  flake.nixosModules.base-desktop-gnome = {
    imports =
      (with inputs.self.nixosModules; [
        x-server
        gnome
        base
      ])
      ++ [
      ];

  };

}
