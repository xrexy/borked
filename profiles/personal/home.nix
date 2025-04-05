{ userSettings, config, ... }:

{
  programs.home-manager.enable = true;
  home.stateVersion = "24.11";

  home.username = userSettings.username;
  home.homeDirectory = userSettings.homeDirectory;

  xdg.userDirs = {
    extraConfig = {
      XDG_GAMES_DIR = "${config.home.homeDirectory}/Games";
      XDG_MINECRAFT_SERVERS_DIR =
        "${config.home.homeDirectory}/MinecraftServers";
    };
  };

  imports = [ ../work/home.nix ../../user/app/protonup.nix ];
}
