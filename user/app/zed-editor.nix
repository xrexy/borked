{ pkgs, ... }:

{
  home.packages = (with pkgs; [ zed-editor nil nixd nixfmt ]);

  programs.zed-editor = {
    enable = true;

    extensions =
      [ "html" "nix" "warp-one-dark" "bearded-icon-theme" "vue" "emmet" ];

    userSettings = {
      theme = "Warp One Dark";
      icon_theme = "Bearded Icon Theme";
      vim_mode = true;
      languages = {
        Nix = {
          language_servers = [ "nil" "!nixd" ];
          formatter = { external = { command = "nixfmt"; }; };
        };
      };
    };
  };
}
