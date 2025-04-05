{ ... }:

{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        showHelp = false;
        showDesktopNotification = false;
        disableTrayIcon = true;
        copyPathAfterSave = true;
      };
    };
  };
}
