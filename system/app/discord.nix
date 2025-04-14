{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (discord.override {
      withOpenASAR = true;
      withTTS = true;
    })
    vencord-web-extension
    webcord-vencord
  ];
}
