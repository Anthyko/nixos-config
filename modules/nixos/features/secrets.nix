_: {
  flake.nixosModules.secrets = _: {
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/var/lib/sops-nix/keys.txt";
    };
  };
}
