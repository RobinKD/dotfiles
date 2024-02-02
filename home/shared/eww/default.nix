{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.hm-modules.waybar;
  cfgDir = ./conf;
in with lib; {
  options.hm-modules.eww = { enable = mkEnableOption "eww"; };

  config = mkIf cfg.enable {
    programs.eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = cfgDir;
    };
  };
}
