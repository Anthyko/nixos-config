{
  config,
  pkgs,
  ...
}:
{
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

}
