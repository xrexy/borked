{ pkgs, userSettings, ... }:

let
  colormap = pkgs.writeShellScriptBin "colormap" ''
    COLORMAPDIR="${userSettings.homeDirectory}/.config/colormap.local"

    cat $COLORMAPDIR
  '';
in { environment.systemPackages = [ colormap ]; }
