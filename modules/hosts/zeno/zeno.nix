{ inputs, self, ... }: {

  flake.nixosConfigurations.zeno = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.base
      self.nixosModules.base-desktop
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.zeno-module
    ];
  };
  flake.nixosModules.zeno-module = {
    imports = [
      ./../../../nixos-configs/zeno/configuration.nix
      {
        home-manager.sharedModules = [
          inputs.nixvim.homeModules.nixvim
          self.homeModules.base
          self.homeModules.base-desktop
          self.homeModules.multimedia-player
        ];
home-manager.useGlobalPkgs = true;
        home-manager.users.anthony = import ../../../home-manager/anthony/home.nix;
      }

    ];

  };

}
