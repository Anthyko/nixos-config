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

        urAccepted = 0;
      };
      openDefaultPorts = true;
      user = system.users.main;
      dataDir = "/home/${system.users.main}/.syncthing-sync"; # default destination for file sync
      configDir = "/home/${system.users.main}/.config/syncthing-nix";
    };
    systemd.targets.multi-user.wants = [ "syncthing@${system.users.main}.service" ];
    # zeno NU24NWV-KGIJWAI-5P7H2LC-XMRYXUN-LSUW3UX-FILZD6P-HQDB4H2-MKSTFQ3
    # aurele I63UFAH-7VZARBA-7F25VC7-3OXNISH-GYFQ2OD-RWBJP3N-SHVDA4O-M5QFVAY
    # mark GFHIJIA-USGMC6L-ZI25Z4C-I4SCE6V-WJERPFI-64EHP7L-CUJY6HM-35NMAAJ
  };
  flake.nixosModules.zeno-file-sync = { config, ... }: {
    sops.secrets."syncthing/key" = {
      sopsFile = ../../../secrets/zeno.yaml;
      key = "syncthing-key";
    };

    sops.secrets."syncthing/cert" = {
      sopsFile = ../../../secrets/zeno.yaml;
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
        };
        folders = {
          "multi" = {
            path = "/home/${system.users.main}/sync/multi";
            devices = [ "mark" ];
          };
          "notes" = {
            path = "/home/${system.users.main}/sync/notes";
            devices = [
              "mark"
              "pocket"
            ];
          };
          "minimal" = {
            path = "/home/${system.users.main}/sync/minimal";
            devices = [ "pocket" ];
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
        };
        folders = {
          "multi" = {
            path = "/home/${system.users.main}/sync/multi";
            devices = [ "zeno" ];
          };
          "notes" = {
            path = "/home/${system.users.main}/sync/notes";
            devices = [
              "zeno"
              "pocket"
            ];
          };
        };
      };
    };
  };
}
