{ pkgs, ... }:

{
  environment.variables.XCURSOR_THEME = "Quintom_Ink";
  environment.variables.XCURSOR_SIZE = "24";
  environment.variables.HYPRCURSOR_THEME = "Quintom_Ink";
  environment.variables.HYPRCURSOR_SIZE = "24";
  qt.enable = true;
  qt.platformTheme = "gtk2";
  qt.style = "gtk2";

  environment.systemPackages = with pkgs; [
    waybar
    rofi-wayland
    dunst

    # (pkgs.fluent-gtk-theme.overrideAttrs (oldAttrs: {
    #   colorVariants = [ "dark" ];
    #   sizeVariants = "compact";
    # }))
    quintom-cursor-theme
    papirus-icon-theme
  ];
}
