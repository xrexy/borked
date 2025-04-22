{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [ xfce.exo ];

  programs.xfconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
      thunar-vcs-plugin
      thunar-media-tags-plugin
    ];
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
}
