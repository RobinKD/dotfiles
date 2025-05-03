{
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
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
    vlc

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
    ib-tws

    # Chat
    signal-desktop
    telegram-desktop

    # LLMs
    (ollama.override { acceleration = "cuda"; })

  ];

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
