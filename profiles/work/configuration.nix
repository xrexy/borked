{ pkgs, systemSettings, userSettings, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [ ../../system/hardware/configuration.nix
      ../../system/hardware/kernel.nix
      ../../system/hardware/systemd.nix
      ../../system/hardware/graphics.nix
      ../../system/hardware/printing.nix
      ../../system/hardware/time.nix
      ../../system/hardware/sound.nix
      ../../system/app/noisetorch.nix
      ../../system/app/bitwarden.nix
    ];

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    zsh
    kitty
    wget
    home-manager
    fastfetch
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = systemSettings.hostname;

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = systemSettings.timezone;

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
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Define a user account. Set a password with ‘passwd’.
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" "input" "render" "video" "dialout" ];
    packages = [];
    uid = 1000;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.fontDir.enable = true;

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

   system.stateVersion = "24.11";
}
