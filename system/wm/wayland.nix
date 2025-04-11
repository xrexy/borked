{ pkgs, ... }: {
  imports = [ ../fonts.nix ../services/dbus.nix ];

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

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
      options = "caps:escape";
    };
  };
}
