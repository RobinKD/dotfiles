{ inputs, pkgs, ... }:
let
  myEmacs = (import ./emacs.nix { inherit pkgs; });
in
with pkgs;
{
  services.emacs = {
    enable = true;
    package = myEmacs.packaged-emacs; # replace with emacs-gtk, or a version provided by the community overlay if desired.
  };
  environment.systemPackages = [
    # Basic
    git
    ntfs3g
    wget
    ripgrep
    gcc
    alacritty
    pavucontrol
    brightnessctl

    # Always useful
    librewolf
    gparted
    gpg-tui
    featherpad
    libreoffice
    nomacs
    cinnamon.nemo
    libnotify
    cmake
    gnumake
    libtool
    sops
    age
    eza
    fzf
  ] ++ myEmacs.system_packages;

  services.gvfs.enable = true; # For finding other devices & trash with FM
}
