{
  config,
  lib,
  pkgs,
  ...
}:
# Sorry Copilot or whatever, you won't have anything except my username...
let
  cfg = config.hm-modules.nightshift;
in
with lib;
{
  options.hm-modules.nightshift = {
    enable = mkEnableOption "nightshift";
  };

  config = mkIf cfg.enable {
    # Change screen color at night
    services.gammastep = {
      enable = true;
      provider = "manual";
      latitude = 48.85;
      longitude = 2.35;
      temperature = {
        day = 5500;
        night = 3500;
      };
      settings = {
        general = {
          fade = 1;
        };
      };
    };

    home.packages = with pkgs; [
      ddcutil
      ddcui
    ];

    home.file.".config/gammastep/hooks/nightshift.sh".text = ''
      #!/bin/bash
      case $1 in
        period-changed)
        case $3 in
          night)
          # 10=brightness, 12=contrast
          for ddcutil detect | grep Display | cut -d" " -f2 | while read -r nb; do
            ddcutil -d $nb setvcp 10 10
          done
          ;;
          transition)
          for ddcutil detect | grep Display | cut -d" " -f2 | while read -r nb; do
            ddcutil -d $nb setvcp 10 20
          done
          ;;
          daytime)
          for ddcutil detect | grep Display | cut -d" " -f2 | while read -r nb; do
            ddcutil -d $nb setvcp 10 40
          done
          ;;
        esac
        ;;
      esac
    '';
  };
}
