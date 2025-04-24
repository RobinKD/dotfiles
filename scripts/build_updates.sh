#!/usr/bin/env sh

nix flake update --flake $HOME/.dotfiles/
nix build "$HOME/.dotfiles#nixosConfigurations.$HOSTNAME.config.system.build.toplevel" -o $HOME/.dotfiles/build_updates
