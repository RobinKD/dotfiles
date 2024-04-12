{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.display-manager;
in
with lib;
{
  options.modules.display-manager = {
    sddm.enable = mkEnableOption "sddm";
    lightdm.enable = mkEnableOption "lightgdm";
  };

  config = mkIf (cfg.sddm.enable || cfg.lightdm.enable) (mkMerge [
    {
      services.xserver.enable = true;
      assertions = [
        {
          assertion =
            (count (x: x) [
              cfg.sddm.enable
              cfg.lightdm.enable
            ]) == 1;
          message = "Choose only one display manager";
        }
      ];
    }
    (mkIf cfg.sddm.enable {
      environment.systemPackages = with pkgs; [
        sddm-sugar-candy-theme
        sddm-sugar-dark-theme
        libsForQt5.qt5.qtgraphicaleffects
      ];

      services.xserver.displayManager.sddm = {
        enable = true;
        settings = {
          General = {
            InputMethod = "";
          };
        };
        theme = "sugar-candy";
      };
    })
    (mkIf cfg.lightdm.enable {
      # TODO
      services.xserver.displayManager.lightdm = {
        enable = true;
        greeters.mini.enable = true;
      };
    })
  ]);
}
