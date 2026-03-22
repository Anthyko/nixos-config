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
}
