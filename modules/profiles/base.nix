{ inputs, ... }: {

  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.nixosModules.base = {
    imports = (with inputs.self.nixosModules; [
      dns-server
      ntp
      nix-config
      file-sync
      tailscale
      secrets
    ]) ++ [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
    ];
  };

  flake.nixosModules.base-desktop = {
    imports = (with inputs.self.nixosModules; [
      display-manager
      x-server
      niri
    ]) ++ [
      inputs.stylix.nixosModules.stylix
    ];

  };


  flake.homeModules.base = { inputs, ... }: {

    imports = [
      inputs.nixvim.homeModules.nixvim
      ../../home-manager/common/programs/nixvim.nix
    ];
  };

  flake.homeModules.base-desktop = { inputs, ... }: {

    imports = [
      inputs.self.homeModules.niri
      inputs.self.homeModules.terminal
    ];
  };


}
