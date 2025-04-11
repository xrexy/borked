{ pkgs, ... }:

{
  programs.dconf.enable = true;
  services.dbus = {
    enable = true;
    implementation = "broker";
    packages = with pkgs; [ xfce.xfconf gnome2.GConf ];
  };
}
