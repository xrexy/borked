#!/bin/sh

# Script to update everything... I'm too lazy and dumb to remember all this

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pushd $SCRIPT_DIR &> /dev/null;

# Update flake
sudo nix flake update;
sudo nix-channel --update;
nix-channel --update;

# Update system and user configurations
sudo nixos-rebuild switch --flake .
home-manager switch -b backup --flake .

popd &> /dev/null;
