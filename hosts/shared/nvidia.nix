{ config, pkgs, ... }:
{
  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = true;
      modesetting.enable = true;

      # Might cause sleep crashes
      powerManagement.enable = true;

      # forceFullCompositionPipeline = true;
      prime = {
        sync.enable = false;
        offload = {
          enable = false;
          #   enableOffloadCmd = true;
        };
        reverseSync.enable = true;
      };
    };
  };
}
