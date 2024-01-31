#!/usr/bin/env sh

nix flake update $HOME/.dotfiles/
nix build "$HOME/.dotfiles#nixosConfigurations.$HOSTNAME.config.system.build.toplevel" -o $HOME/.dotfiles/build_updates
