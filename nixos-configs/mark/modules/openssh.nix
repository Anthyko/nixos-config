{ config
, pkgs
, ...
}: {
  services.openssh = {
    enable = true;
    ports = [ 13076 ];
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      UseDns = true;
      X11Forwarding = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };
}
