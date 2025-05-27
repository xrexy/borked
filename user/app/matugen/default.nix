{ pkgs, config, ... }:

{
  home.packages = with pkgs; [ matugen ];

  home.file."${config.xdg.configHome}/matugen/config.toml" = {
    source = ./matugen.toml;
  };
}
