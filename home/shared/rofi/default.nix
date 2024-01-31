{ config, lib, pkgs, ... }:
/* Styles and types for rofi are a shameless steal from https://github.com/adi1090x/rofi
   Thanks!!
*/
let
  cfg = config.hm-modules.rofi;
  gtk-icon-theme = config.hm-modules.gtk-theme.icon-theme;
  rofi-color-theme = ./style/colors + "/${cfg.color-theme}.rasi";
  launcher-style = cfg.launcher-style;
  launcher-type = cfg.launcher-type;
  launcher-rasi = builtins.toFile "launcher.rasi"
    (builtins.replaceStrings [ "shared/colors.rasi" "real" ] [
      "${rofi-color-theme}"
      "background"
    ] (builtins.readFile
      (./style/launchers + "/${launcher-type}/${launcher-style}.rasi")));
  launcher-rofi = pkgs.writeTextFile {
    name = "rofi-launcher";
    destination = "/bin/rofi-launcher";
    executable = true;
    text =
      "rofi -show drun -theme ${launcher-rasi} -show-icons -icon-theme ${gtk-icon-theme}";
  };
in with lib; {
  options.hm-modules.rofi = {
    enable = mkEnableOption "rofi";
    color-theme = mkOption {
      type = types.str;
      description = "Color theme used for Rofi";
      default = "catppuccin";
    };
    launcher-style = mkOption {
      type = types.str;
      description = "Style used by launcher";
      default = "style-3";
    };
    launcher-type = mkOption {
      type = types.str;
      description = "Launcher type used";
      default = "type-3";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ launcher-rofi ];
    # TODO Config to work with both leftwm and hyprland
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      font = "Iosevka Nerd Font 10";
    };
  };
}
