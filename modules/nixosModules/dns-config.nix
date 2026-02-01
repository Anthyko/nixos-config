{ inputs, lib, ... }: {
  flake.nixosModules.dns-config = { pkgs, ... }: {
    networking.useHostResolvConf = false;

    networking.nameservers = [ "127.0.0.1" ];
    networking.networkmanager.dns = lib.mkForce "none";

  };
}

