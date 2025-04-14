{ pkgs, ... }:

let
  python = pkgs.python313.withPackages
    (ps: with ps; [ loguru pulsectl pywayland requests pygobject3 ]);

  mediaplayer = pkgs.writeShellScriptBin "mediaplayer" ''
    # Make sure GI can find all the typelib files
    export GI_TYPELIB_PATH="${pkgs.gobject-introspection}/lib/girepository-1.0:${pkgs.glib.out}/lib/girepository-1.0:${pkgs.playerctl}/lib/girepository-1.0:$GI_TYPELIB_PATH"

    # Make sure dynamic libraries can be found
    export LD_LIBRARY_PATH="${pkgs.glib.out}/lib:${pkgs.playerctl}/lib:$LD_LIBRARY_PATH"

    # Make sure Python can find the modules
    export PYTHONPATH="${python}/${python.sitePackages}:$PYTHONPATH"

    # Run the Python script
    exec ${python}/bin/python3 "$HOME/.dotfiles/scripts/mediaplayer.py" "$@"
  '';
in {
  environment.systemPackages =
    [ mediaplayer pkgs.playerctl pkgs.glib pkgs.gobject-introspection ];
}
