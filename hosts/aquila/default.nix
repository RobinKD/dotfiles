{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  hw = inputs.hardware.nixosModules;
  hm = config.home-manager.users.keanu;
  hmm = hm.hm-modules;
in
{
  imports = [
    hw.common-cpu-amd
    hw.common-gpu-nvidia
    hw.common-pc-ssd
    ./hardware-configuration.nix

    ../shared
    ../shared/nvidia.nix
    ../shared/custom-services/auto-build.nix
    ../shared/custom-services/backup-passwords.nix
    ../shared/specialisations/no-nvidia.nix
  ];

  modules = {
    # DE / WM
    desktop = {
      plasma.enable = true;
      leftwm.enable = true;
      hyprland.enable = true;
      # sway.enable = true;
    };

    # Display manager
    display-manager = {
      sddm.enable = true;
      # lightdm.enable = true;
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking = {
    hostName = "aquila";
    # useDHCP = true; # Handled via networkmanager
  };
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Hyprland stuff
  # allow wayland lockers to unlock the screen
  security.pam.services.swaylock.text = lib.mkIf hmm.hyprland.enable "auth include login";
  # Add Hyprland to xsessions
  services.displayManager.sessionPackages = lib.mkIf hmm.hyprland.enable [
    inputs.hyprland.packages.${pkgs.hostPlatform.system}.default
  ];

  # Control backlight
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl1", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  # Flipper zero udev rules
  hardware.flipperzero = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
  webex
  ];
}
