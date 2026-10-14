{
  lib,
  pkgs,
  config,
  ...
}:
let
  domain = "git.anthonyhengy.fr";
  port = 3003;
  inherit (lib.lists) head;
in
{
  services.nginx = {
    virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations."/".proxyPass = "http://localhost:${toString port}";
    };
  };

  sops.secrets."forgejo/admin-password" = {
    sopsFile = ../../../../secrets/mark/secrets.yaml;
    owner = config.users.users.forgejo.name;
    group = config.users.users.forgejo.group;
    mode = "0400";
  };
  services.forgejo = {
    enable = true;
    database.type = "sqlite3";
    database.path = "${config.services.forgejo.stateDir}/data/forgejo.db";
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = domain;
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://${domain}/";
        HTTP_PORT = 3003;
        SSH_PORT = head config.services.openssh.ports;
      };
      other = {
        SHOW_FOOTER_VERSION = false;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = false;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };
  systemd.services.forgejo.preStart =
    let
      adminCmd = "${lib.getExe config.services.forgejo.package} admin user";
      pwd = config.sops.secrets."forgejo/admin-password";
      user = "anthony"; # Note, Forgejo doesn't allow creation of an account named "admin"
    in
    ''
      if [ ! -s "${pwd.path}" ]; then
        echo "ERROR: Forgejo secret is missing or empty"
        exit 1
      fi

      password="$(tr -d '\n' < "${pwd.path}")"

      if [ -z "$password" ]; then
        echo "ERROR: Forgejo password is empty after reading the secret"
        exit 1
      fi
        ${adminCmd} create --admin --email "root@localhost" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
        
        #${adminCmd} change-password --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
    '';
}
