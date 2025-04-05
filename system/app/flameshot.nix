{ pkgs, ... }:

{
  anvironment.plasma6.excludePackages = with pkgs; [ spectacle ];
  environment.systemPackages = with pkgs;
    [ (flameshot.override { enableWlrSupport = true; }) ];
}
