{ inputs, ... }: {
  flake.nixosModules.desktop-env = { pkgs, ... }: {
    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
  };

  flake.nixosModules.window-compositor = { pkgs, ... }: {
    # every program used by the desktop environment should be here
    environment.systemPackages = with pkgs; [
      hyprland # Wayland compositor
      waybar # Status bar
      kitty # Terminal emulator
      grim # Screenshots
      slurp # Select regions for screenshots
      mako # Notifications
      swappy # Annotate screenshots
      xwayland
    ];

    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = true;
    stylix = {
      enable = true;

      # Palette Gruvbox Dark Medium
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    };


  };


}
