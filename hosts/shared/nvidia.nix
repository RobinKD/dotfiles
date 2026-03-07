{ config, pkgs, ... }:
{
  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
      # package = config.boot.kernelPackages.nvidiaPackages.latest;
      # TODO: remove once NVIDIA 580+ supports Linux 6.19 natively (upstream fix pending).
      package =
        let
          base = config.boot.kernelPackages.nvidiaPackages.latest;
          cachyos-nvidia-patch = pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
            sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
          };
        in
        base
        // {
          open = base.open.overrideAttrs (oldAttrs: {
            patches = (oldAttrs.patches or [ ]) ++ [ cachyos-nvidia-patch ];
          });
        };
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
