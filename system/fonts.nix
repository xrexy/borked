{ pkgs, ... }:

{
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerd-font-patcher
    nerd-fonts.fira-code
    monocraft
  ];
}
