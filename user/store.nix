{ ... }:

{
  home.file = {
    ".config/hypr".source = ../store/hypr;
    ".config/rofi".source = ../store/rofi;
    ".config/waybar".source = ../store/waybar;
    ".config/dunst".source = ../store/dunst;
    ".config/xfce4/helpers.rc".source = ../store/xfce4.helpers.rc;
  };
}
