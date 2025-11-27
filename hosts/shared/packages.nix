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
    mpv
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
    inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system}.nix-alien

    # Trading
    tradingview
    ib-tws

    # Chat
    signal-desktop
    telegram-desktop

    # Gaming
    lutris
    (qemu.overrideAttrs (oldAttrs: {
      version = "9.2.4";
      src = pkgs.fetchurl {
        url = "https://download.qemu.org/qemu-9.2.4.tar.xz";
        sha256 = "sha256-88wcTqv9soghisPjN2Pb6eJ22LyJC4Z6IzXVjeLd05o=";
      };
      patches = (oldAttrs.patches or [ ]) ++ [
        (pkgs.fetchurl {
          url = "https://github.com/Scrut1ny/Hypervisor-Phantom/raw/refs/heads/main/Hypervisor-Phantom/patches/QEMU/intel-qemu-9.2.4.patch"; # change with amd, if you have amd cpu
          sha256 = "sha256-BV6TvEtY0EnGJuTSWB128FGGDdjiqmYXKKnfwIVtzYw="; # Replace with actual hash
        })
        (pkgs.fetchurl {
          url = "https://github.com/Scrut1ny/Hypervisor-Phantom/raw/refs/heads/main/Hypervisor-Phantom/patches/QEMU/libnfs6-qemu-9.2.4.patch";
          sha256 = "sha256-HjZbgwWf7oOyvhJ4WKFQ996e9+3nVAjTPSzJfyTdF+4="; # Replace with actual hash
        })
      ];
    }))
    quickemu

    # LLMs
    # (ollama.override { acceleration = "cuda"; })

    tor-browser

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
