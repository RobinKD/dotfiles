{ pkgs, config, lib, ... }:
let
  cfg = config.hm-modules.pass;
  homeDir = config.home.homeDirectory;
in with lib; {
  options.hm-modules.pass = { enable = mkEnableOption "pass"; };

  config = mkIf cfg.enable {
    programs.password-store = {
      enable = true;
      settings = { PASSWORD_STORE_DIR = "${homeDir}/.password-store"; };
    };

    programs.browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };
  };
}
