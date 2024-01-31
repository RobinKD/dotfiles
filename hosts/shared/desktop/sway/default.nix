{ config, lib, pkgs, ... }:
let
  hm = config.home-manager.users.keanu;
  hmm = hm.hm-modules;
  cfg = config.modules.desktop.sway;
in with lib; {
  options.modules.desktop = { sway.enable = mkEnableOption "desktop"; };

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true; # so that gtk works properly
      extraPackages = with pkgs; [ wdisplays ];
      extraOptions = [ "--unsupported-gpu" ];
      extraSessionCommands = ''
        export QT_QPA_PLATFORM=wayland-egl
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
      '';
    };
  };
}
