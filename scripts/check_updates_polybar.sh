#!/usr/bin/env sh

updates=$(nix store diff-closures /run/current-system $HOME/.dotfiles/build_updates)
nb_updates=$($updates | wc -l)

printf '%s' $nb_updates
