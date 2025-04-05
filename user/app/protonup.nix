{ pkgs, ... }:

# /home/desktop/.steam/root/compatibilitytools.d/GE-Proton9-27
{
  home.packages = with pkgs; [ protonup ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
