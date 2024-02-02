{ config, lib, pkgs, ... }:
let
  hm = config.home-manager.users.keanu;
  username = hm.home.username;
  homeDir = hm.home.homeDirectory;
  hostname = config.networking.hostName;
in {
  systemd.paths."backup-passwords" = {
    pathConfig = {
      PathChanged = "${homeDir}/.password-store";
      Unit = "backup-passwords.service";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services."backup-passwords" = {
    path = [ pkgs.gnutar pkgs.gzip pkgs.gnupg pkgs.sops ];
    script = ''
      bkp_file="${homeDir}/.dotfiles/secrets/pass_bkp.tar.gz"
      tar czf $bkp_file ${homeDir}/.password-store/
      sops --config ${homeDir}/.dotfiles/.sops.yaml -e $bkp_file > $bkp_file
    '';
    serviceConfig = {
      Type = "simple";
      User = "${username}";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
