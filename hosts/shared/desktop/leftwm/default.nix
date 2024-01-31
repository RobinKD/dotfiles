{ config, lib, pkgs, ... }:
let
  hm = config.home-manager.users.keanu;
  hmm = hm.hm-modules;
  cfg = config.modules.desktop.leftwm;
in with lib; {
  options.modules.desktop = { leftwm.enable = mkEnableOption "desktop"; };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hmm.polybar.enable;
        message = "Polybar not enabled for leftwm";
      }
      {
        assertion = hmm.rofi.enable;
        message = "Rofi not enabled for leftwm";
      }
      {
        assertion = hmm.dunst.enable;
        message = "Dunst not enabled for leftwm, you won't get notifications";
      }
    ];

    environment.systemPackages = with pkgs; [
      xclip
      scrot
      networkmanagerapplet
      check-uptime
      picom
      feh
      betterlockscreen
      arandr
    ];

    services.xserver.windowManager.leftwm.enable = true;
    programs.nm-applet.enable = true;

    # Prevent screen blanking out
    environment.extraInit = ''
      xset s off -dpms
    '';
  };
}
