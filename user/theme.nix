{ pkgs, ... }:

{
  gtk.theme = {
    enable = true;
    name = "Colloid-Dark";
    package = (pkgs.colloid-gtk-theme.overrideAttrs (oldAttrs: {
      themeVariants = [ "orange" ];
      colorVariants = [ "dark" ];
      sizeVariants = "compact";
      tweaks = [ "black" "rimless" ];
    }));
  };
}
