{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.bitwarden ];
}
