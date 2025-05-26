{ pkgs, ... }:

{
  imports = [
    ../work/configuration.nix

    ../../system/app/games
    ../../system/app/pywal16.nix
    ../../system/app/piper.nix
  ];

  environment.systemPackages = with pkgs; [ stremio r2modman youtube-music ];
}
