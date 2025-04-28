{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ gnome-keyring ];
  services.gnome.gnome-keyring = { enable = true; };
}
