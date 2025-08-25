{ inputs, systemSettings, ... }:

{
  programs.caelestia = {
    enable = true;
    package =
      inputs.caelestia-shell.packages.${systemSettings.system}.default.override {
        withCli = true;
      };
    settings = {
      paths = {
        # mediaGif TODO abo
        # sessionGif TODO abo
      };
      bar = {
        dragThreshold = 20;
        sizes = {
          innerWidth = 45;
          windowPreviewSize = 400;
          trayMenuWidth = 275;
          networkWidth = 275;
        };
        entries = [
          {
            id = "idleInhibitor";
            enabled = true;
          }
          # {
          #   id = "logo";
          #   enabled = true;
          # }
          {
            id = "workspaces";
            enabled = true;
          }
          {
            id = "spacer";
            enabled = true;
          }
          {
            id = "activeWindow";
            enabled = true;
          }
          {
            id = "spacer";
            enabled = true;
          }
          {
            id = "tray";
            enabled = true;
          }
          {
            id = "clock";
            enabled = true;
          }
          {
            id = "statusIcons";
            enabled = true;
          }
          {
            id = "power";
            enabled = true;
          }
        ];
        status = {
          showAudio = true;
          showNetwork = true;
          showKbLayout = true;
          showBattery = false;
          showBluetooth = false;
        };
        workspaces = {
          activeIndicator = true;
          activeLabel = "";
          activeTrail = false;
          label = "  ";
          occupiedBg = false;
          occupiedLabel = "";
          perMonitorWorkspaces = true;
          showWindows = true;
          shown = 5;
        };
      };
    };
    cli = {
      enable = true;
      package = inputs.caelestia-cli.packages.${systemSettings.system}.default;
      settings = { };
    };
  };
}
