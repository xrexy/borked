{ pkgs, ... }: {
  imports = [ ../services/dbus.nix ];

  environment.systemPackages = with pkgs; [
    wayland
    waydroid
    (sddm-chili-theme.override {
      # https://github.com/MarianArlt/sddm-chili?tab=readme-ov-file#theming-the-theme
      themeConfig = {
        background =
          "https://c4.wallpaperflare.com/wallpaper/147/871/818/digital-digital-art-artwork-illustration-drawing-hd-wallpaper-preview.jpg";
        blur = true;
      };
    })
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "chili";
    enableHidpi = true;
    package = pkgs.kdePackages.sddm;
  };

  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];
  };
}
