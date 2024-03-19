{
  imports = [ ./hardware-configuration.nix ../shared/locale.nix ];

  # For Windows dual boot
  boot.loader.grub.useOSProber = true;

  networking = { hostName = "cassiopee"; };
  services.openssh.enable = true;

  users = {
    mutableUsers = false;
    users.rpi = {
      isNormalUser = true;
      initialPassword = "rpipass";
      extraGroups = [ "wheel" ];
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "24.05";
}
