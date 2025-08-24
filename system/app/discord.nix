{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ equibop ];
}
