{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ telegram-desktop telegram-bot-api ];
}
