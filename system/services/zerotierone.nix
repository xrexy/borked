{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ zerotierone ];
  services.zerotierone = {
    enable = true;
    port = 36676;
  };
}
