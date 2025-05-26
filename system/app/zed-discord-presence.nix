{ pkgs }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "discord-presence-lsp";
  # TODO update version
  version = "d6622e5d4dbbf9f61764458c2b50ba2e58789307";
  cargoHash = "sha256-JLNCEeo9fKeV4vTtPs+Yj2wRO1RKP2fuetrPlXcPBjA=";

  src = pkgs.fetchFromGitHub {
    owner = "xhyrom";
    repo = "zed-discord-presence";
    rev = version;
    hash = "sha256-RmpY0xkJYNDYn6SWNdKGpPetmBxf2/xY25FLeJqf0Po=";
  };

  cargoBuildFlags = "--package discord-presence-lsp";
}
