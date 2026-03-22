{ inputs
, lib
, ...
}:
{
  flake.nixosModules.secrets = { pkgs, ... }: {
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/var/lib/sops-nix/keys.txt";
  };
}
