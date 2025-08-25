{ pkgs, ... }:

{
  imports = [
    ../work/configuration.nix

    ../../system/app/games
    ../../system/app/piper.nix
  ];

  environment.systemPackages = with pkgs; [
    stremio
    r2modman
    youtube-music
    anydesk
    clipse
    cliphist
    yt-dlp
    nicotine-plus
    clementine
    ani-cli
    ani-skip
    trash-cli
    geoclue2
    gammastep
  ];
}
