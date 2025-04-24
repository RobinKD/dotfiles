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
in
{
  systemd.timers."system-auto-build" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "2h";
      Unit = "system-auto-build.service";
    };
  };

  systemd.services."system-auto-build" = {
    path = [
      pkgs.nix
      pkgs.git
    ];
    script = ''
      nix flake update --flake ${homeDir}/.dotfiles/
      nix build "${homeDir}/.dotfiles#nixosConfigurations.${hostname}.config.system.build.toplevel" -o ${homeDir}/.dotfiles/build_updates
    '';
    serviceConfig = {
      Type = "simple";
      User = "${username}";
    };
  };
}
