{ inputs, pkgs, ... }:
let
  hypr-pkgs =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [ ./wayland.nix ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    portalPackage = hypr-pkgs.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    pyprland
    hyprland
    hyprpicker
    hyprcursor
    hyprlock
    hypridle
    wezterm
    helix
    zathura
    mpv
    vlc
    imv
  ];
}
