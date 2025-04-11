{ systemSettings, ... }:

{
  # services.timesyncd.enable = true;
  time.hardwareClockInLocalTime = true;
  time.timeZone = systemSettings.timezone;
}
