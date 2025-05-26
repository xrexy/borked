{ pkgs, inputs, systemSettings, userSettings, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../../system/hardware/fonts.nix
    ../../system/hardware/configuration.nix
    ../../system/hardware/bootloader.nix
    ../../system/hardware/garbage-collector.nix
    ../../system/hardware/screen.nix
    ../../system/hardware/display-manager.nix
    ../../system/hardware/systemd.nix
    ../../system/hardware/graphics.nix
    ../../system/hardware/printing.nix
    ../../system/hardware/time.nix
    ../../system/hardware/disable-nvidia.nix # the day you see me buy anything nvidia is the day I'll force myself into a mental asylum

    ../../system/app/zsh.nix
    ../../system/app/nix-ld.nix
    ../../system/app/spotify.nix
    ../../system/app/noisetorch.nix
    ../../system/app/bitwarden.nix
    ../../system/app/discord.nix
    ../../system/app/thunar.nix
    ../../system/app/telegram.nix
    ../../system/app/dysk.nix

    ../../system/bin

    ../../system/services

    ../../system/wm/hyprland.nix
    ../../system/theme.nix
  ];

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    inputs.swww.packages.${systemSettings.system}.swww
    nix-prefetch-scripts
    vim
    kitty
    tldr
    wget
    home-manager
    fastfetch
    xclip
    figlet
    ydotool
    grimblast
    unrar
    p7zip
    starship
    htop
    alacritty
    hoppscotch
    android-studio

    google-chrome
  ];

  # Enable ram swap
  zramSwap.enable = true;

  networking.hostName = systemSettings.hostname;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n.defaultLocale = systemSettings.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.extraLocale;
    LC_IDENTIFICATION = systemSettings.extraLocale;
    LC_MEASUREMENT = systemSettings.extraLocale;
    LC_MONETARY = systemSettings.extraLocale;
    LC_NAME = systemSettings.extraLocale;
    LC_NUMERIC = systemSettings.extraLocale;
    LC_PAPER = systemSettings.extraLocale;
    LC_TELEPHONE = systemSettings.extraLocale;
    LC_TIME = systemSettings.extraLocale;
  };

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Define a user account. Set a password with ‘passwd’.
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups =
      [ "networkmanager" "wheel" "docker" "input" "render" "video" "dialout" ];
    packages = [ ];
    uid = 1000;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };

  programs.ssh = { startAgent = true; };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-gtk ];
  };

  system.stateVersion = "24.11";
}
