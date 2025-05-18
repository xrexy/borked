{ pkgs, ... }:

{
  # coreutils for nohup to autostart easyeffects (look at store/hypr/hyprland.conf)
  environment.systemPackages = with pkgs; [ easyeffects coreutils ];
}
