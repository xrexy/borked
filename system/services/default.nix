{ pkgs, ... }:

{
  imports = [
    ./dbus.nix
    ./pipewire.nix
    ./zerotierone.nix
    ./gnome-keyring.nix
    ./easyeffects.nix
    ./docker.nix
  ];

  # TODO add usbguard

  systemd.packages = with pkgs; [ auto-cpufreq ];

  programs.direnv.enable = true;
  programs.fish.enable = true;
  programs.xfconf.enable = true;

  services.upower.enable = true;
  services.mpd.enable = true;
  services.tumbler.enable = true;
  services.fwupd.enable = true;

  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = true;

  environment.systemPackages = with pkgs; [
    at-spi2-atk
    qt6.qtwayland
    psi-notify
    poweralertd
    playerctl
    psmisc
    grim
    slurp
    imagemagick
    swappy
    ffmpeg_6-full
    wl-screenrec
    # wl-clipboard
    # wl-clip-persist
    xdg-utils
    wtype
    wlrctl
    avizo
    wlogout
    gifsicle
  ];
}
