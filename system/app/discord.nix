{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;
    [
      (discord.override {
        withOpenASAR = true;
        withTTS = true;
      })
      # vesktop
    ];
}
