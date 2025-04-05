{ ... }:

{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        showHelp = false;
        showDesktopNotification = false;
        copyPathAfterSave = true;
      };
    };
  };
}
