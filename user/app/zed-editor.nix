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
      "bearded-icon-theme"
      "vue"
      "emmet"
      "toml"
      "one-black-theme"
      "discord-presence"
    ];

    userSettings = {
      lsp = {
        nil = {
          initialization_options = { formatting.command = [ "nixfmt" ]; };
        };
        nix = { binary = { path_lookup = true; }; };
        discord_presence = {
          initialization_options = {
            # Application ID for the rich presence (don't touch it unless you know what you're doing)
            application_id = "1263505205522337886";
            # Base URL for all language icons
            base_icons_url =
              "https://raw.githubusercontent.com/xhyrom/zed-discord-presence/main/assets/icons/";

            state = "Working on {filename}";
            details = "In {workspace}";
            # URL for the large image
            large_image =
              "{base_icons_url}/{language:lo}.png"; # :lo lowercase the language name
            large_text = "{language:u}"; # :u capitalizes the first letter
            # URL for the small image
            small_image = "{base_icons_url}/zed.png";
            small_text = "Zed";

            # Idle settings - when you're inactive
            idle = {
              timeout = 300; # Idle timeout in seconds (300 seconds = 5 minutes)

              # Action to take when idle
              # `change_activity` - changes the activity to idle with the following details
              # `clear_activity` - clears the activity (hides it)
              action = "change_activity";

              state = "My final brain cell is trying to put something together";
              details = "(who let bro cook)";
              large_image = "{base_icons_url}/zed.png";
              large_text = "Zed";
              small_image = "{base_icons_url}/nix.png";
              small_text = "boo";
            };

            # Rules to disable presence in specific workspaces
            rules = {
              mode = "blacklist"; # Can also be "whitelist"
              paths = [ ];
            };

            git_integration = true;
          };
        };
      };
      theme = "system-matugen";
      icon_theme = "Bearded Icon Theme";
      vim_mode = false;
      ui_font_size = 14;
      buffer_font_size = 12;
      buffer_font_family = "Monocraft";

      lsp_highlight_debounce = 9999999999;
      relative_line_numbers = false;
      show_completions_on_input = false;
      # features = { edit_predicton_provider = "zed"; };
      # edit_predictions = { mode = "subtle"; };
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
