{ pkgs, ... }:

{
  home.packages =
    (with pkgs; [ zed-editor nil nixd nixfmt vue-language-server ]);

  programs.zed-editor = {
    enable = true;

    extensions =
      [ "html" "nix" "warp-one-dark" "bearded-icon-theme" "vue" "emmet" ];

    userSettings = {
      theme = "Warp One Dark";
      icon_theme = "Bearded Icon Theme";
      vim_mode = true;
      ui_font_size = 14;
      buffer_font_size = 12;

      relative_line_numbers = true;
      show_completions_on_input = false;
      features = { edit_predicton_provider = "zed"; };
      edit_predictions = { mode = "subtle"; };
      project_panel = { dock = "right"; };
      assistant = {
        dock = "left";
        version = "2";
        default_model = {
          provider = "zed.dev";
          model = "claude-3-7-sonnet-latest";
        };
      };
      languages = {
        Nix = {
          language_servers = [ "nil" "!nixd" ];
          formatter = { external = { command = "nixfmt"; }; };
        };
      };
    };
  };
}
