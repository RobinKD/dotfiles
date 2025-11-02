{
  pkgs,
  inputs,
  outputs,
  ...
}:
{
  imports = [
    ./nix.nix
    ./bootloader.nix
    ./locale.nix
    ./users.nix
    ./packages.nix
    ./fonts.nix
    ./external-screen-brightness.nix
    ./custom-desktop-items.nix

    ./desktop
    ./display-manager
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  # TODO Check for autoUpgrade
  # system.autoUpgrade = {
  #   enable = true;
  #   operation = "boot";
  #   flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
  #   dates = "weekly";
  # };

  hardware.enableAllFirmware = true;

  networking = {
    networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # Sound
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  # nixpkgs.config.pulseaudio = true;

  services = {
    printing.enable = true;
  };

  # PipeWire currently crashing
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  system.stateVersion = "24.05";
}
