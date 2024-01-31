{
  hardware = {
    opengl = { enable = true; };
    nvidia = {
      modesetting.enable = true;
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
