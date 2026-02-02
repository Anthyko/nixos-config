{ inputs, pkgs, ... }:
{


  flake.homeConfigurations.anthony =
    inputs.homeConfigurations.lib.homeManagerConfiguration {
      modules = [
        (inputs.self.factory.home-base {
          username = "anthony";
          homeDirectory = "/home/anthony";

        })
      ];

      disableStylixKitty = true;
      disableStylixNixvim = true;
      sessionVariables = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };
    };

}
