{ config, lib, pkgs, ... }:
let cfg = config.hm-modules.conky;
in with lib; {
  options.hm-modules.conky = { enable = mkEnableOption "conky"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ conky ];

    home.file.".config/conky" = {
      source = ./conf_dir;
      recursive = true;
    };
  };
}
