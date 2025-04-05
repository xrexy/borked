{
  description = "Borked nix";

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      systemSettings = rec {
        # profile = "work";
        profile = "personal";

        system = "x86_64-linux";
        hostname = "desktop";
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

        wm = "hyprland"; # hyprland / plasma
        wmType = if ((wm == "hyprland") || (wm == "plasma")) then "wayland" else "x11";

        editor = "zeditor";
        spawnEditor = editor;
        terminal = "kitty";
        browser = "brave";
      };

      lib = nixpkgs.lib;

      nixpkgs-patched =
        (import inputs.nixpkgs { system = systemSettings.system; rocmSupport = true; }).applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
          patches = [ ];
        };

      pkgs = import nixpkgs-patched {
        system = systemSettings.system;
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
        # overlays = [ inputs.rust-overlay.overlays.default ];
      };

      pkgs-unstable = import inputs.nixpkgs-patched {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        overlays = [ inputs.rust-overlay.overlays.default ];
      };
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          system = systemSettings.system;
          modules = [ (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix") ];
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      homeConfigurations = {
        desktop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix") ];
          extraSpecialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
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
  };
}
