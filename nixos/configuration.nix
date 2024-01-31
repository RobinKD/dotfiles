# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Home manager built via NixOS
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
      pulseaudio = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # FIXME: Add the rest of your current configuration

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      keanu = import ../home-manager/home.nix;
    };
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-backup";
  };

  boot = {
    initrd.kernelModules = [ "nvidia" "nvidia-modeset" ];
    kernelModules = [ "kvm-amd" "dm-crypt" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "nvidia-drm.modeset=1" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    supportedFilesystems = [ "btrfs" ];

    loader = {
      systemd-boot = {
        enable = false;
        editor = false;
      };
      efi = { canTouchEfiVariables = false; };
      grub = {
        enable = true;
        default = "saved";
        configurationLimit = 5;
        copyKernels = true;
        efiInstallAsRemovable = true;
        efiSupport = true;
        fsIdentifier = "uuid";
        splashMode = "stretch";
        device = "nodev";
        extraEntries = ''
          menuentry "Reboot" {
            reboot
          }
          menuentry "Poweroff" {
            halt
          }
        '';
        extraGrubInstallArgs = [ "--modules=keylayouts" ];
        extraInstallCommands = ''
          loadkeys fr
        '';
      };
    };

  };

  hardware.enableAllFirmware = true;

  networking = {
    hostName = "aquila"; # Define your hostname.
    # Pick only one of the below networking options.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable =
      true; # Easiest to use and most distros use this by default.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  hardware = {
    pulseaudio.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      modesetting.enable = true;
      nvidiaPersistenced = true;
      forceFullCompositionPipeline = true;
      prime = {
        sync.enable = false;
        offload.enable = false;
        reverseSync.enable = true;
        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #  keyMap = "fr";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services = {
    lorri.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];

      # Enable the Plasma 5 Desktop Environment.
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      windowManager.leftwm.enable = true;

      # Configure keymap in X11
      layout = "fr";
      # xkbOptions = {
      #   "eurosign:e";
      #   "caps:escape" # map caps to escape.
      # };
      #
      # screenSection = ''
      #      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      #      Option         "AllowIndirectGLXProtocol" "off"
      #      Option         "TripleBuffer" "on"
      #   '';
      # Enable touchpad support (enabled default in most desktopManager).
      # libinput.enable = true;

    };

    # Enable CUPS to print documents.
    # printing.enable = true;

    # List services that you want to enable:
    # emacs = {
    #   enable = true;
    #   package = pkgs.emacsNativeComp;
    # };

    # Enable the OpenSSH daemon.
    # openssh.enable = true;

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl1", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    '';
  };

  # Enable sound.
  sound.enable = true;

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    keanu = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "nixos";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
      ]; # Enable ‘sudo’ for the user.
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    sessionVariables = { NIXOS_OZONE_WL = "1"; };
    systemPackages = with pkgs; [
      #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      ntfs3g
      git
      featherpad
      glxinfo
      emacsNativeComp
      ripgrep
      (python3.withPackages (ps:
        with ps; [
          numpy
          black
          pandas
          pytest
          joblib
          matplotlib
          scikit-learn
          seaborn
          click
          pyyaml
          pytorch-lightning
          graphviz
          pyqt5
          plotly
        ]))
      (texlive.combine {
        inherit (texlive)
          scheme-medium sttools datetime2 datetime ninecolors multirow fmtcount
          pgfplots adjustbox appendixnumberbeamer tabularray;
      })
      cmake
      nodejs
      xclip
      scrot
      sqlite
      gcc
      mu
      (aspellWithDicts (ps: with ps; [ en fr ]))
      gpg-tui
      gnumake
      libtool
      waybar
      rofi
      swww
      # qt5
      firefox
      qt5ct
      libva
      libnotify
      dunst
      yadm
      pass
      alacritty
      polybar
      conky
      pavucontrol
      nomacs
      picom
      feh
      autorandr
      brightnessctl
      betterlockscreen
      arandr
      discord
      # Work around #159267
      (pkgs.writeShellApplication {
        name = "discord-wayland";
        text = "${pkgs.discord}/bin/discord --use-gl=desktop";
      })
      (pkgs.makeDesktopItem {
        name = "discord-wayland";
        exec = "discord-wayland";
        desktopName = "Discord-Wayland";
      })

      element-desktop
      (pkgs.writeShellApplication {
        name = "element-desktop-wayland";
        text = "NIXOS_OZONE_WL='1' ${pkgs.element-desktop}/bin/element-desktop";
      })
      (pkgs.makeDesktopItem {
        name = "element-desktop-wayland";
        exec = "element-desktop-wayland";
        desktopName = "Element-Wayland";
      })

      networkmanagerapplet
      font-manager
      gnome3.adwaita-icon-theme
      swayidle
      swaylock-effects
      check-uptime
      libreoffice
      direnv
      nvidia-offload
    ];
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    gnupg.agent = {
      enable = true;
      #   enableSSHSupport = true;
    };
    hyprland.enable = true;
    nm-applet.enable = true;

    # Browserpass firefox
    browserpass.enable = true;
    firefox.nativeMessagingHosts.browserpass = true;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    font-awesome
    material-icons
    material-design-icons
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
        "SourceCodePro"
        "Iosevka"
        "JetBrainsMono"
      ];
    })
  ];

  fonts.fontDir.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
