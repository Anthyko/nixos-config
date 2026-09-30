{
  inputs,
  self,
  network,
  system,
  ...
}:
let
  specialArgs = {
    inherit
      inputs
      self
      network
      system
      ;
  };
in
{
  # Builds a NixOS system configuration with Home Manager pre-configured.
  # Abstracts away boilerplate (system, specialArgs, HM options) so each
  # host only declares what makes it unique.
  #
  # Arguments:
  #   modules - list of NixOS modules to include (profiles, host module, etc.)
  #             Home Manager user configuration should be declared inside these modules.
  #
  # Example:
  #   mkNixos [
  #     self.nixosModules.base-desktop
  #     self.nixosModules.zeno-module
  #     { home-manager.users.anthony.imports = [ self.homeModules.anthony-module ]; }
  #   ]
  _module.args.mkNixos =
    modules:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = specialArgs;
      modules = [
      ]
      ++ modules;
    };

  # mkHome is for standalone home-manager configs
  _module.args.mkHome =
    system: modules:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = specialArgs;
      modules = modules;
    };
}
