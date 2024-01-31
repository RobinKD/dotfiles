{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot = {
        enable = false;
        editor = false;
      };
      efi = { canTouchEfiVariables = false; };
      grub = {
        enable = true;
        default = "saved";
        # configurationLimit = 5;
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
        # extraInstallCommands = ''
        #   loadkeys fr
        # '';
      };
    };

  };
}
