{ config, pkgs, userSettings, ... }:

{
  programs.home-manager.enable = true;
  home.stateVersion = "24.11";

  home.username = userSettings.username;
  home.homeDirectory = userSettings.homeDirectory;

  imports = [
    ../../user/app/git.nix
  ];

  home.packages = (with pkgs; [
    zed-editor
    git
    wine
    bottles
    vlc
    obs-studio
    ffmpeg
    movit
    mediainfo
    libmediainfo
    audio-recorder
  ]);

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    SPAWNEDITOR = userSettings.spawnEditor;
    TERM = userSettings.terminal;
    BROWSER = userSettings.browser;
  };

  news.display = "silent";

  services.pasystray.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    documents = "${config.home.homeDirectory}/Media/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    desktop = null;
    publicShare = null;
    extraConfig = {
      XDG_CODE_DIR = "${config.home.homeDirectory}/Code";
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";
      XDG_ARCHIVE_DIR = "${config.home.homeDirectory}/Archive";
      XDG_VM_DIR = "${config.home.homeDirectory}/Machines";
      XDG_PODCAST_DIR = "${config.home.homeDirectory}/Media/Podcasts";
      XDG_BOOK_DIR = "${config.home.homeDirectory}/Media/Books";
    };
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  # TODO Fix mime associations
  xdg.mimeApps.associations.added = { };

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    # name = if (config.stylix.polarity == "dark") then "Papirus-Dark" else "Papirus-Light";
    name = "Papirus-Dark";
  };
}
