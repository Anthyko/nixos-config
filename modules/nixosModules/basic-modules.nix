{ inputs, ... }:
{
  flake.nixosModules.common-modules =
    { pkgs, ... }:
    {
      # This module contains all the shared module between all the nixos configs
      # The bare minimum
      imports = with inputs.self.modules.nixos; [
        dns-config
        dns-server
        file-sync
        ssh-agent
        time-config
        nix-config
      ];

    };

  flake.nixosModules.common-modules-desktop =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        common-modules
        desktop-env

      ];
    };

}
