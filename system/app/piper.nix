{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ piper libratbag ];
  services.ratbagd.enable = true;
}
