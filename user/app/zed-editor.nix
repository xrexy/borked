{ pkgs, ... }:

{
  home.packages = (with pkgs; [
    zed-editor
    nil
    nixd
    nixfmt-classic
    package-version-server
    vue-language-server
    hyprls
  ]);

  programs.zed-editor = {
    enable = true;

    extensions = [
      "html"
      "nix"
      "warp-one-dark"
      "bearded-icon-theme"
      "vue"
      "emmet"
      "toml"
      "one-black-theme"
    ];

    userSettings = {
      lsp = {
        nil = {
          initialization_options = { formatting.command = [ "nixfmt" ]; };
        };
        nix = { binary = { path_lookup = true; }; };
      };
      theme = "One Black";
      icon_theme = "Bearded Icon Theme";
      vim_mode = true;
      ui_font_size = 14;
      buffer_font_size = 12;
      buffer_font_family = "Monocraft";

      lsp_highlight_debounce = 9999999999;
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

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          alt-g = [
            "task::Spawn"
            {
              task_name = "lazygit";
              reveal_target = "center";
            }
          ];
          "alt-d d" = [
            "task::Spawn"
            {
              task_name = "dev";
              reveal_target = "center";
            }
          ];
          "alt-c c" = "project_panel::CollapseAllEntries";
        };
      }
      {
        context = "Editor";
        bindings = { alt-space = "editor::ToggleAutoSignatureHelp"; };
      }
    ];
  };
}
