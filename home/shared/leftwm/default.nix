{ config, lib, nixosConfig, ... }:
with lib; {
  config = mkIf nixosConfig.modules.desktop.leftwm.enable {
    home.file.".config/leftwm" = {
      source = ./conf_dir;
      recursive = true;
    };
  };
}
