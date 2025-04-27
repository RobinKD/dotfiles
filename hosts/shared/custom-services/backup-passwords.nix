{
  config,
  lib,
  pkgs,
  ...
}:
let
  hm = config.home-manager.users.keanu;
  username = hm.home.username;
  homeDir = hm.home.homeDirectory;
  hostname = config.networking.hostName;
  bkp_file = "${homeDir}/.dotfiles/secrets/pass_bkp";
in
{
  systemd.timers."backup-passwords" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "3h";
      Unit = "backup-passwords.service";
    };
  };

  systemd.services."backup-passwords" = {
    path = [
      pkgs.gnutar
      pkgs.gzip
      pkgs.gnupg
      pkgs.sops
    ];
    script = ''
      if [ ! -f ${bkp_file}.tar.gz ] || [ $(find ${homeDir}/.password-store/ -type f -newer ${bkp_file}.tar.gz | wc -l) -gt 0 ] || [ $(stat --format "%Z" ${homeDir}/.password-store) -gt $(stat --format "%Z" ${bkp_file}.tar.gz) ]; then
         tar czf ${bkp_file}2.tar.gz ${homeDir}/.password-store/
         sops --config ${homeDir}/.dotfiles/.sops.yaml -e ${bkp_file}2.tar.gz > ${bkp_file}.tar.gz
         rm ${bkp_file}2.tar.gz
      fi
    '';
    serviceConfig = {
      Type = "simple";
      User = "${username}";
    };
  };
}
