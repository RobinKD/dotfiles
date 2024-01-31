{ config, lib, pkgs, ... }:
let
  hm = config.home-manager.users.keanu;
  username = hm.home.username;
  homeDir = hm.home.homeDirectory;
  hostname = config.networking.hostName;
in {
  systemd.timers."backup-passwords" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "6h";
      Unit = "backup-passwords.service";
    };
  };

  systemd.services."backup-passwords" = {
    path = [ pkgs.gnutar pkgs.gzip pkgs.gnupg pkgs.sops ];
    script = ''
      bkp_file="${homeDir}/.dotfiles/secrets/pass_bkp.tar.gz"
      if [ ! -f $bkp_file ] || [ $(find ${homeDir}/.password-store/ -type f -newer $bkp_file | wc -l) -gt 0 ]; then
         tar czf ${homeDir}/.dotfiles/secrets/pass_bkp.tar.gz ${homeDir}/.password-store/
         sops --config ${homeDir}/.dotfiles/.sops.yaml -e $bkp_file > $bkp_file
      fi
    '';
    serviceConfig = {
      Type = "simple";
      User = "${username}";
    };
  };
}
