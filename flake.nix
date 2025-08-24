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

      overlays = [ inputs.rust-overlay.overlays.default ];

      inherit (builtins) mapAttrs;
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/configuration.nix")
          ];
          specialArgs = {
            pkgs = import nixpkgs {
              system = systemSettings.system;
              overlays = overlays;
              config.allowUnfree = true;
            };
            pkgs-stable = import nixpkgs-stable {
              system = systemSettings.system;
              config.allowUnfree = true;
            };
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      homeConfigurations = {
        desktop = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = systemSettings.system;
            overlays = overlays;
            config.allowUnfree = true;
          };

          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
          ];
          extraSpecialArgs = {
            pkgs-stable = import nixpkgs-stable {
              system = systemSettings.system;
              config.allowUnfree = true;
            };

            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
            flakePkgs = mapAttrs (_: input:
              input.legacyPackages.${systemSettings.system} or { }
              // input.packages.${systemSettings.system} or { }) inputs;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-stable.url = "github:nix-community/home-manager/release-25.05";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    jerry = {
      url = "github:justchokingaround/jerry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    stylix.url = "github:danth/stylix";

    swww.url = "github:LGFae/swww";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };
}
