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
    yt-dlp
  ];
}
