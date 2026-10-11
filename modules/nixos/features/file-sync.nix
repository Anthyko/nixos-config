{
  self,
  network,
  system,
  ...
}:
{
  flake.nixosModules.file-sync = _: {
    services.syncthing = {
      enable = true;
      options = {

        urAccepted = -1;
      };
      openDefaultPorts = true;
      user = system.users.main;
      dataDir = "/home/${system.users.main}/.syncthing-sync"; # default destination for file sync
      configDir = "/home/${system.users.main}/.config/syncthing-nix";
    };
  };
  flake.nixosModules.zeno-file-sync = { config, ... }: {
    sops.secrets."syncthing/key" = {
      sopsFile = ../../../secrets/zeno/zeno.yaml;
      key = "syncthing-key";
    };

    sops.secrets."syncthing/cert" = {
      sopsFile = ../../../secrets/zeno/zeno.yaml;
      key = "syncthing-cert";
    };
    imports = [
      self.nixosModules.file-sync
    ];

    services.syncthing = {
      key = config.sops.secrets."syncthing/key".path;
      cert = config.sops.secrets."syncthing/cert".path;
      settings = {
        devices = {
          "mark" = {
            id = network.syncthing.mark;
          };
          "pocket" = {
            id = network.syncthing.pocket;
          };
          "aurele" = {
            id = network.syncthing.aurele;
          };
        };
        folders = {
          "multi" = {
            path = "/home/${system.users.main}/sync/multi";
            devices = [
              "mark"
              "aurele"
            ];
          };
          "notes" = {
            path = "/home/${system.users.main}/sync/notes";
            devices = [
              "mark"
              "pocket"
              "aurele"
            ];
          };
          "minimal" = {
            path = "/home/${system.users.main}/sync/minimal";
            devices = [
              "pocket"
              "aurele"
            ];
            versioning = {
              type = "staggered";
              params.maxAge = "31536000"; # 1y
            };
          };
        };
      };
    };
  };
  flake.nixosModules.mark-file-sync = { config, ... }: {
    sops.secrets."syncthing/key" = {
      sopsFile = ../../../secrets/mark.yaml;
      key = "syncthing-key";
    };

    sops.secrets."syncthing/cert" = {
      sopsFile = ../../../secrets/mark.yaml;
      key = "syncthing-cert";
    };
    imports = [
      self.nixosModules.file-sync
    ];

    services.syncthing = {
      key = config.sops.secrets."syncthing/key".path;
      cert = config.sops.secrets."syncthing/cert".path;
      settings = {
        devices = {
          "zeno" = {
            id = network.syncthing.zeno;
            autoAcceptFolders = true;
          };
          "pocket" = {
            id = network.syncthing.pocket;
          };
          "aurele" = {
            id = network.syncthing.aurele;
          };
        };
        folders = {
          "multi" = {
            path = "/home/${system.users.main}/sync/multi";
            devices = [
              "zeno"
              "aurele"
            ];
            versioning = {
              type = "staggered";
              params.maxAge = "31536000"; # 1y
            };
          };
          "notes" = {
            path = "/home/${system.users.main}/sync/notes";
            devices = [
              "zeno"
              "pocket"
              "aurele"
            ];
            versioning = {
              type = "staggered";
              params.maxAge = "7776000"; # 90 days
            };
          };
        };
      };
    };
  };
  flake.nixosModules.aurele-file-sync = { config, ... }: {
    sops.secrets."syncthing/key" = {
      sopsFile = ../../../secrets/aurele.yaml;
      key = "syncthing-key";
    };

    sops.secrets."syncthing/cert" = {
      sopsFile = ../../../secrets/mark.yaml;
      key = "syncthing-cert";
    };
    imports = [
      self.nixosModules.file-sync
    ];

    services.syncthing = {
      key = config.sops.secrets."syncthing/key".path;
      cert = config.sops.secrets."syncthing/cert".path;
      settings = {
        devices = {
          "zeno" = {
            id = network.syncthing.zeno;
            autoAcceptFolders = true;
          };
          "pocket" = {
            id = network.syncthing.pocket;
          };
        };
        folders = {
          "multi" = {
            path = "/home/${system.users.main}/sync/multi";
            devices = [
              "zeno"
              "mark"
            ];
            versioning = {
              type = "staggered";
              params.maxAge = "31536000"; # 1y
            };
          };
          "notes" = {
            path = "/home/${system.users.main}/sync/notes";
            devices = [
              "zeno"
              "pocket"
              "mark"
            ];
            versioning = {
              type = "staggered";
              params.maxAge = "7776000"; # 90 days
            };
          };
          "minimal" = {
            path = "/home/${system.users.main}/sync/minimal";
            devices = [
              "zeno"
              "pocket"
            ];
            versioning = {
              type = "staggered";
              params.maxAge = "31536000"; # 1y
            };
          };
        };
      };
    };
  };
}
