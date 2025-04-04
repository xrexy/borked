{ pkgs }:

pkgs.buildFHSEnv {
  name = "discord-presence-fhs";
  runScript = "${pkgs.stdenv.lib.fileContents ./wrapper.sh}"; # We'll create this script next
  packages = with pkgs; [
    glibc.bin
  ];
}
