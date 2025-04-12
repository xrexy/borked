{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [ kitty ];
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font.name = "Monocraft";
    settings = {
      background_opacity = lib.mkForce "0.85";
      confirm_os_window_close = -1;
      background = "#020618";
    };
  };
}
