{ pkgs, ... }:

{
  # fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-font-patcher
    nerd-fonts.fira-code
    monocraft
  ];
}
