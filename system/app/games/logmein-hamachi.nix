{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ logmein-hamachi haguichi ];
  services.logmein-hamachi.enable = true;
  programs.haguichi.enable = true;
}
