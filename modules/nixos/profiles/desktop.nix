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
        inputs.stylix.nixosModules.stylix
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
        inputs.stylix.nixosModules.stylix
      ];

  };

}
