{ config, lib, pkgs, ... }:
let cfg = config.hm-modules.polybar;
in with lib; {
  options.hm-modules.polybar = { enable = mkEnableOption "polybar"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ polybar ];
    # services.polybar = {
    #   enable = true;
    #   # TODO Config
    # };
  };
}
