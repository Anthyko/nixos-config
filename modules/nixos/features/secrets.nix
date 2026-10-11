_: {
  flake.nixosModules.secrets = _: {
    sops = {
      defaultSopsFormat = "yaml";
      age.keyFile = "/var/lib/sops-nix/keys.txt";
    };
  };
}
