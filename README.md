# Borked

This is my NixOS setup using flakes, no idea what I'm doing so please don't use it...

### Using
Apply user:
```sh
home-manager switch --flake /home/desktop/.dotfiles
```

Apply system:
```sh
sudo nixos-rebuild switch --flake /home/desktop/.dotfiles
```
