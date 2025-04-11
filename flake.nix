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
        extraLocale = "bg_BG.UTF-8"; # can just use locale
      };

      userSettings = rec {
        username = "desktop";
        name = "xrexy";
        email = "rkolev@proton.me";

        # Don't use trailing slashes
        homeDirectory = "/home/" + username;
        dotfilesDir = homeDirectory + "/.dotfiles";

        editor = "zeditor";
        spawnEditor = editor;
        terminal = "kitty";
        browser = "brave";

        font = "Monocraft";
        fontPkg = pkgs.monocraft;
      };

      pkgs = import nixpkgs { system = systemSettings.system; };
      pkgs-stable = import nixpkgs-stable.legacyPackages {
        system = systemSettings.system;
      };

      lib = pkgs.lib;
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
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
            inherit lib;
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
            inherit lib;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-stable.url = "github:nix-community/home-manager/release-24.05";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    hyprland.url = "github:hyprwm/Hyprland";

    stylix.url = "github:danth/stylix";
  };
}
