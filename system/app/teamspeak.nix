{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ teamspeak6-client ];
}
