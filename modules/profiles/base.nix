{ inputs, ... }: {

  flake.nixosModules.base = {
    imports = with inputs.self.nixosModules; [
      dns-server
      ntp
      nix-config
      file-sync
      tailscale
      secrets
    ];
  };
}
