{ pkgs, ... }: {
  environment.systemPackages =
    [ pkgs.zed-editor (pkgs.callPackage ./zed-discord-presence.nix { }) ];
}
