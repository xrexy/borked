{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ nomachine-client ];
}
