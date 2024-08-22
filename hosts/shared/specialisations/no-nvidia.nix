{ lib, ... }:
# TODO Not working yet -> Goes to black screen
with lib;
{
  specialisation = {
    no-nvidia.configuration = {
      hardware = {
        graphics = {
          enable = mkForce false;
        };
        nvidiaOptimus.disable = true;
        nvidia = {
          modesetting.enable = mkForce false;
          powerManagement.enable = mkForce false;
          nvidiaPersistenced = mkForce false;
          forceFullCompositionPipeline = mkForce false;
          prime = {
            sync.enable = mkForce false;
            offload = {
              enable = mkForce false;
              #   enableOffloadCmd = mkForce false;
            };
            reverseSync.enable = mkForce false;
            amdgpuBusId = mkForce "";
            nvidiaBusId = mkForce "";
            intelBusId = mkForce "";
          };
        };
      };
    };
  };
}
