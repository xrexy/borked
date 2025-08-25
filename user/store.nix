{ ... }:

{
  home.file = {
    ".config/hypr".source = ../store/hypr;
    ".config/rofi".source = ../store/rofi;
    ".config/dunst".source = ../store/dunst;
    ".config/xfce4/helpers.rc".source = ../store/xfce4.helpers.rc;
    "Media/Pictures/Wallpapers".source = ../wallpapers;
  };
}
