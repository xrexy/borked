{ pkgs, ... }:
let theme = "cuts";
in {
  boot.plymouth = {
    enable = true;
    font =
      "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    theme = theme;
    themePackages = [
      (pkgs.adi1090x-plymouth-themes.overrideAttrs
        (oldAttrs: { selected_themes = [ theme ]; }))
    ];
  };
}
