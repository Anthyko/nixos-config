_: {
  flake.nixosModules.ssh-agent = _: {
    # Whether to start the OpenSSH agent when you log in
    programs.ssh.startAgent = true;
  };
}
