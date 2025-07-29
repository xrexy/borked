{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.zed-editor
    (pkgs.callPackage ./zed-discord-presence.nix { })
    pkgs.kdePackages.qtdeclarative # QML support
    pkgs.alejandra # nix formatter
  ];
}
