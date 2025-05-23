{
  description = "Borked nix";

  outputs = inputs@{ self, nixpkgs, nixpkgs-stable, home-manager, ... }:
    let
      systemSettings = {
        profile = "personal";

        system = "x86_64-linux";
        hostname = "nixos";
        timezone = "Europe/Sofia";
        locale = "en_US.UTF-8";
        extraLocale = "bg_BG.UTF-8";
      };

      userSettings = rec {
        username = "desktop";
        name = "xrexy";
        email = "rkolev@proton.me";

        # Don't use trailing slashes
        homeDirectory = "/home/" + username;
        dotfilesDir = "~/.dotfiles";

        editor = "zeditor";
        spawnEditor = editor;
        terminal = "kitty";
        browser = "brave";

        font = "Monocraft";
        fontPkg = pkgs.monocraft;
      };

      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${systemSettings.system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${systemSettings.system};
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/configuration.nix")
          ];
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
            inherit pkgs-stable;
          };
        };
      };

      homeConfigurations = {
        desktop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
          ];
          extraSpecialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
            inherit pkgs-stable;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-stable.url = "github:nix-community/home-manager/release-24.05";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    hyprland.url = "github:hyprwm/Hyprland";

    stylix.url = "github:danth/stylix";

    swww.url = "github:LGFae/swww";
  };
}
