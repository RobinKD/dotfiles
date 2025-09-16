{
  config,
  lib,
  pkgs,
  ...
}:
/*
  Styles and types for rofi are a shameless steal from https://github.com/adi1090x/rofi
  Thanks!!
*/
let
  cfg = config.hm-modules.rofi;
  gtk-icon-theme = config.hm-modules.gtk-theme.icon-theme;
  rofi-color-theme = ./style/colors + "/${cfg.color-theme}.rasi";
  launcher-style = cfg.launcher-style;
  launcher-type = cfg.launcher-type;
  launcher-rasi =
    type: style:
    builtins.toFile "launcher.rasi" (
      builtins.replaceStrings
        [ "shared/colors.rasi" "black / 10" ]
        [
          "${rofi-color-theme}"
          "black / 75"
        ]
        (builtins.readFile (./style/launchers + "/${type}/${style}.rasi"))
    );
  launcher-rofi = pkgs.writeShellScriptBin "rofi-launcher" ''rofi -show drun -theme ${launcher-rasi launcher-type launcher-style} -show-icons -icon-theme ${gtk-icon-theme}'';
  window-rofi = pkgs.writeShellScriptBin "rofi-windows" ''rofi -modes window -show window -theme ${launcher-rasi launcher-type "style-5"} -show-icons -icon-theme ${gtk-icon-theme}'';
in
with lib;
{
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
    # TODO Config to work with both leftwm and hyprland
    home.packages = with pkgs; [
      launcher-rofi
      window-rofi
    ];
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      font = "Iosevka Nerd Font 10";
    };

    # Rofi network manager dmenu config and style
    home.file.".config/networkmanager-dmenu/config.ini".text = ''
      [dmenu]
      dmenu_command = rofi -dmenu -width 30 -i -password -theme ${launcher-rasi "type-4" "style-2"}
      rofi_highlight = true
      pinentry = pinentry-gtk-2
      wifi_icons = 󰤯󰤟󰤢󰤥󰤨
      format = {name}  {sec}  {icon}

      [editor]
      terminal = emacsclient
      gui_if_available = True
    '';
  };
}
