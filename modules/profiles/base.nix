{ inputs, ... }: {

  flake.nixosModules.base = {
    imports = (with inputs.self.nixosModules; [
      dns-server
      ntp
      nix-config
      file-sync
      tailscale
      secrets
    ])++ [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
      ];
  };

  flake.nixosModules.base-desktop = {
    imports = (with inputs.self.nixosModules; [
      display-manager
      x-server
      niri
    ])++ [
    inputs.stylix.nixosModules.stylix
      ];

  };
}
