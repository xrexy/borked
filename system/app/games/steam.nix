{ pkgs, ... }:

{
  environment.systemPackages = (with pkgs; [ mangohud ]);

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;
}
# gamemoderun %command%
# mangohud %command%
# gamescope %command%
