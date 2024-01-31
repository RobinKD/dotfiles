{ config, lib, pkgs, ... }:
let cfg = config.hm-modules.gtk-theme;
in with lib; {
  options.hm-modules.gtk-theme = {
    enable = mkEnableOption "gtk-theme";
    theme = mkOption {
      type = types.str;
      description = "GTK Theme used";
      default = "Catppuccin-Latte-Standard-Sapphire-Light";
    };
    icon-theme = mkOption {
      type = types.str;
      description = "GTK Theme used for icons";
      default = "Papirus-Light";
    };
    cursor-theme = mkOption {
      type = types.str;
      description = "GTK Theme used for cursors";
      default = "Catppuccin-Mocha-Sapphire-Cursors";
    };
    cursor-size = mkOption {
      type = types.str;
      description = "Cursor size";
      default = "32";
    };
    font-name = mkOption {
      type = types.str;
      description = "Font used in GTK apps";
      default = "SauceCodePro Nerd Font Bold 10";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      catppuccin-cursors.mochaSapphire
      (catppuccin-gtk.override {
        accents = [ "lavender" "sapphire" "sky" ];
        tweaks = [ "rimless" "black" ];
        variant = "latte";
      })
      (catppuccin-papirus-folders.override {
        accent = "lavender";
        flavor = "latte";
      })
    ];

  };
}
