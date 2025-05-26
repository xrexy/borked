{ pkgs, userSettings, ... }:

let
  changewallpaper = pkgs.writeShellScriptBin "changewallpaper" ''
    BACKGROUND_DIR="${userSettings.homeDirectory}/.dotfiles/wallpapers"

    apply() {
        local selected="$1"
        shift

        # Apply the selected wallpaper
        wal -i "$selected" "$@"

        # Reload apps
        hyprctl reload
    }

    menu() {
        # Either select wallpaper with 'm' and quit with q, or go to the wallpaper and select it with Q (will select the one you're hovering over)
        CHOICE=$(nsxiv -obt $BACKGROUND_DIR/*)

        case $CHOICE in
            *.*) apply "$CHOICE";;
            *) exit 0;;
        esac
    }

    case "$#" in
        0) menu;;
        1) apply "$1";;
        2) apply "$1" --theme $2;;
        *) echo "Invalid option";;
    esac
  '';
in { environment.systemPackages = [ changewallpaper pkgs.nsxiv ]; }
