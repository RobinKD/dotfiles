{ config, lib, ... }:
let cfg = config.hm-modules.gpg;
in with lib; {
  options.hm-modules.gpg = { enable = mkEnableOption "gpg"; };

  config = mkIf cfg.enable {
    programs = { gpg = { enable = true; }; };

    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      defaultCacheTtl = 25200; # 7h
      maxCacheTtl = 86400; # 24h
      pinentryFlavor = "qt";
    };
  };
}
