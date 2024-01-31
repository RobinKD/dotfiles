# Import this from the pre-flake configuration.
{ config, pkgs, ... }: {
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
