{ config
, pkgs
, ...
}:
let
  domain = "anthonyhengy.fr";
  mailHost = "mail.anthonyhengy.fr";
in
{
  networking.firewall.allowedTCPPorts = [
    25
    993
  ];
  #users.users.dovecot2.extraGroups = [ "acme" ];
  users.users.postfix.extraGroups = [ "acme" ];
  # Dedicated system user for virtual mail storage.
  users.groups.vmail.gid = 5000;

  users.users.vmail = {
    isSystemUser = true;
    uid = 5000;
    group = "vmail";
    home = "/var/vmail";
    createHome = true;
  };
  sops.secrets."postfix/virtual-mailboxes" = {
    sopsFile = ../../../../secrets/secrets.yaml;
    owner = "postfix";
    group = "postfix";
    mode = "0440";
  };
  sops.secrets."postfix/smtp2go-sasl-passwd" = {
    sopsFile = ../../../../secrets/secrets.yaml;
    owner = "postfix";
    group = "postfix";
    mode = "0440";
  };

  sops.secrets."dovecot/users" = {
    sopsFile = ../../../../secrets/secrets.yaml;
    owner = "dovecot2";
    group = "dovecot2";
    mode = "0400";
  };
  services.nginx.virtualHosts.${mailHost} = {
    enableACME = true;
    forceSSL = true;
    # locations."/" = {
    #proxyPass = "http://127.0.0.1:3000";
    #};
  };
  security.acme.certs.${mailHost} = {
    group = "acme";
  };
  services.postfix = {
    enable = true;

    # Mail server identity.
    hostname = mailHost;
    domain = domain;
    origin = domain;


    # Do not include domain here because we use virtual_mailbox_domains.
    destination = [
      "$myhostname"
      "localhost.$mydomain"
      "localhost"
    ];

    # Outgoing mail relay through SMTP2GO.

    settings.main = {
      # Outgoing mail relay through SMTP2GO.
      relayhost = [ "[mail-eu.smtp2go.com]:587" ];
      smtpd_relay_restrictions = [
        "permit_mynetworks"
        "reject_unauth_destination"
      ];

      # Basic SMTP hardening.
      disable_vrfy_command = "yes";
      smtpd_helo_required = "yes";

      # Basic sender/recipient checks.
      smtpd_recipient_restrictions = [
        "permit_mynetworks"
        "reject_unauth_destination"
        "reject_non_fqdn_recipient"
        "reject_unknown_recipient_domain"
      ];

      smtpd_sender_restrictions = [
        "reject_non_fqdn_sender"
        "reject_unknown_sender_domain"
      ];
      smtp_sasl_auth_enable = "yes";
      smtp_sasl_password_maps =
        "texthash:${config.sops.secrets."postfix/smtp2go-sasl-passwd".path}";

      smtp_sasl_security_options = "noanonymous";
      smtp_sasl_tls_security_options = "noanonymous";

      smtp_tls_security_level = "encrypt";
      smtp_tls_CAfile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      virtual_transport = "lmtp:unix:/run/dovecot2/lmtp";
      # Accept mail for this virtual domain.
      virtual_mailbox_domains = [ domain ];
      virtual_mailbox_maps =
        [ "texthash:${config.sops.secrets."postfix/virtual-mailboxes".path}" ];

    };

  };
  services.dovecot2 = {
    enable = true;

    # https://doc.dovecot.org/2.3/configuration_manual/howto/postfix_dovecot_lmtp/
    # https://doc.dovecot.org/2.3/configuration_manual/howto/postfix_and_dovecot_sasl/
    settings = {
      protocols = [ "imap" "lmtp" ];

      # Store mail as Maildir under /var/vmail.
      mail_location = "maildir:/var/vmail/%d/%n/Maildir";

      # Use the virtual mail storage user.
      mail_uid = "vmail";
      mail_gid = "vmail";

      # Require TLS for IMAP authentication.
      ssl = "required";
      ssl_cert = "</var/lib/acme/${mailHost}/fullchain.pem";
      ssl_key = "</var/lib/acme/${mailHost}/key.pem";
      service = [
        {
          _section = {
            name = "lmtp";
          };
          "unix_listener lmtp" = {
            mode = "0660";
            user = "postfix";
          };
        }
      ];

      # Virtual users from sops-managed passwd-file.
      passdb = {
        driver = "passwd-file";
        args = "scheme=SHA512-CRYPT ${config.sops.secrets."dovecot/users".path}";
      };

      userdb = {
        driver = "passwd-file";
        args = config.sops.secrets."dovecot/users".path;
      };


      auth_mechanisms = [ "plain" "login" ];
      disable_plaintext_auth = true;
    };
  };
}
