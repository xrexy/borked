{ pkgs, userSettings, ... }:

let
  changewallpaper = pkgs.writeShellScriptBin "changewallpaper" ''
    BACKGROUND_DIR="${userSettings.homeDirectory}/.dotfiles/wallpapers"

    apply() {
        COLORMAP_FILE="${userSettings.homeDirectory}/.config/colormap.local"

        # Apply the selected wallpaper
        echo "Wallpaper: $1" > $COLORMAP_FILE
        matugen image "$1" --show-colors -m "dark" >> $COLORMAP_FILE
        caelestia wallpaper --file "$1"
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
        *) echo "Invalid option";;
    esac
  '';
in { environment.systemPackages = [ changewallpaper pkgs.nsxiv ]; }
