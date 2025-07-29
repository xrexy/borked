{ pkgs, ... }:

{
  # fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-font-patcher
    nerd-fonts.fira-code # rofi
    # nerd-fonts.caskaydia-cove # cool nerd font
    monocraft # system & zed-editor
  ];
}
