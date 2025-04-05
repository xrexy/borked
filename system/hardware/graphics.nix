{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    extraPackages = [
      pkgs.rocmPackages.clr.icd
    ];
  };
}
