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
        nixd = {
          settings = {
            nixpkgs = {
              expr =
                "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs {}";
            };
            formatting = { command = [ "alejandra" ]; };
          };
        };
        qml = { binary = { arguments = [ "-E" ]; }; };
        nix = { binary = { path_lookup = true; }; };
        discord_presence = {
          initialization_options = {
            # Application ID for the rich presence (don't touch it unless you know what you're doing)
            application_id = "1263505205522337886";
            # Base URL for all language icons
            base_icons_url =
              "https://raw.githubusercontent.com/xhyrom/zed-discord-presence/main/assets/icons/";

            state = "My final brain cell is trying to put something together";
            details = "(who let bro cook)";
            large_image = "{base_icons_url}/zed.png";
            large_text = "Zed";
            small_image = "{base_icons_url}/nix.png";
            small_text = "boo";

            # Idle settings - when you're inactive
            idle = {
              timeout = 300; # Idle timeout in seconds (300 seconds = 5 minutes)

              # Action to take when idle
              # `change_activity` - changes the activity to idle with the following details
              # `clear_activity` - clears the activity (hides it)
              action = "change_activity";
              state = "bing chilling";

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
      ui_font_size = 12;
      buffer_font_size = 10;
      buffer_font_family = "Monocraft";
      ui_font_family = "Monocraft";

      lsp_highlight_debounce = 9999999999;
      relative_line_numbers = false;
      show_completions_on_input = false;
      # features = { edit_predicton_provider = "zed"; };
      # edit_predictions = { mode = "subtle"; };
      project_panel = { dock = "right"; };
      agent = {
        dock = "left";
        default_model = {
          provider = "zed.dev";
          model = "claude-3-7-sonnet-latest";
        };
        single_file_review = true;
        # TODO setup feature-specific models
        # https://zed.dev/docs/ai/agent-settings#feature-specific-models
      };
      languages = {
        Nix = {
          language_servers = [ "nixd" "!nil" ];
          formatter = { external = { command = "nixfmt"; }; };
        };
        QML = {
          formatter = {
            external = {
              command = "sh";
              arguments = [
                "-c"
                "tmp=$(mktemp --suffix .qml); cat > $tmp; qmlformat $tmp"
              ];
            };
          };
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
