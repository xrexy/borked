{ inputs, pkgs, ... }:
let
  hypr-pkgs =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [ ./wayland.nix ../services/gnome-keyring-nix ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    portalPackage = hypr-pkgs.xdg-desktop-portal-hyprland;
  };

  services.xserver = {
    excludePackages = [ pkgs.xterm ];
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "chili";
      enableHidpi = true;
      package = pkgs.sddm;
    };
  };
}
