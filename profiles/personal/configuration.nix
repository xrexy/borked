{ pkgs, ... }:

{
  imports = [
    ../work/configuration.nix
    ../../system/app/games
    ../../system/app/piper.nix
  ];

  environment.systemPackages = with pkgs; [ youtube-music ];
}
