_: {
  flake.nixosModules.secrets = _: {
    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/var/lib/sops-nix/keys.txt";
  };
}
