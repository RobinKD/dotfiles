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
    networkmanagerapplet

    # Always useful
    librewolf
    gparted
    gpg-tui
    featherpad
    libreoffice
    nomacs
    nemo
    libnotify
    cmake
    gnumake
    libtool
    sops
    age
    eza
    fzf
    ripgrep-all
    inputs.nix-alien.packages.${pkgs.system}.nix-alien

    # Trading
    qemu
    quickemu
    tradingview
  ] ++ myEmacs.system_packages;

  programs.nix-ld.enable = true;

  services.gvfs.enable = true; # For finding other devices & trash with FM

  # Virtualized Windows apps
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "keanu" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # Or Dockerized
  virtualisation.docker.enable = true;
  users.users.keanu.extraGroups = [ "docker" ];
}
