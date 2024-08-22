{
  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
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
