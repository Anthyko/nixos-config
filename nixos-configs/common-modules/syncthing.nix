{
  config,
  pkgs,
  ...
}:
{
  # SYNCTHING
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "anthony";
    dataDir = "/home/anthony/.config/syncthing-data";
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder from syncthing
  # migration script
  system.activationScripts.syncthing-migrate = ''
    old="/var/lib/syncthing"
    new="/home/anthony/.config/syncthing-data"
    if [ -d "$old" ] && [ ! -d "$new" ]; then
      echo "Migrating Syncthing data from $old to $new..."
      mkdir -p "$new"
      cp -a "$old/." "$new/"
      chown -R anthony:users "$new"
    fi
  '';
}
