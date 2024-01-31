{ config, lib, pkgs, ... }:
let cfg = config.modules.desktop.plasma;
in with lib; {
  options.modules.desktop = { plasma.enable = mkEnableOption "desktop"; };

  config =
    mkIf cfg.enable { services.xserver.desktopManager.plasma5.enable = true; };
}
