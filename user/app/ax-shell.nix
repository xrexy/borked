{ config, pkgs, ... }:
let
  ax-shell = builtins.fetchGit {
    url = "https://github.com/HeyImKyu/Ax-Shell.git";
    ref = "main";
    rev = "f244e77d1ce5d2340944650b569ffea280ef9233";
  };

  python = pkgs.python313.withPackages
    (ps: with ps; [ loguru pulsectl pywayland requests pygobject3 ]);
in {
  imports = [ ./matugen ];

  home.file."${config.xdg.configHome}/Ax-Shell" = { source = ax-shell; };

  home.file.".local/share/fonts/tabler-icons.ttf" = {
    source = "${ax-shell}/assets/fonts/tabler-icons/tabler-icons.ttf";
  };

  home.packages = with pkgs; [
    uwsm
    cava
    fabric
    fabric-cli
    python
    (fabric-run-widget.override {
      extraPythonPackages = with python3Packages; [
        ijson
        numpy
        pillow
        psutil
        requests
        setproctitle
        toml
        watchdog
      ];
      extraBuildInputs =
        [ fabric-gray networkmanager networkmanager.dev playerctl ];
    })
  ];
}
