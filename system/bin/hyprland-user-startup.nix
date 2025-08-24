{ pkgs, ... }:

let
  hyprland-user-startup = pkgs.writeShellScriptBin "hyprland-user-startup" ''
    #!/usr/bin/env bash

    # Update DBus environment variables
    dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland

    # Start easyeffects
    nohup easyeffects --gapplication-service &

    # Start clipse
    clipse -listen &

    # Start ydotoold
    ydotoold &

    # Start hypridle
    hypridle &

    # Start swww-daemon
    swww-daemon --no-cache &

    # Start caelestia shell
    caelestia-shell &

    echo "Hyprland startup script executed successfully!"
  '';
in { environment.systemPackages = [ hyprland-user-startup ]; }
