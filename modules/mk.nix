{ inputs, self, ... }:
{
  _module.args.mkNixos =
    modules:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs self; };
      modules = [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "";
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ]
      ++ modules;
    };
}
