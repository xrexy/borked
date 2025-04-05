{ pkgs, ... }:

{
  # TODO NEEDS PRIVATE AND PUBLIC KEYS
  environment.systemPackages = [ pkgs.bitwarden ];
}
