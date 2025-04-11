{ pkgs, ... }:

{
  imports = [ ./plymouth ];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    consoleLogLevel = 3;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };

    initrd = {
      enable = true;
      systemd.enable = true;
    };
  };
}
