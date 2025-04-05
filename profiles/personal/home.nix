{ pkgs, userSettings, ... }:

{
  programs.home-manager.enable = true;
  home.stateVersion = "24.11";

  home.username = userSettings.username;
  home.homeDirectory = userSettings.homeDirectory;

  imports = [ ../work/home.nix ];
}
