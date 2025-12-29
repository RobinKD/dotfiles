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
  updateIbTws = pkgs.writeShellScriptBin "update-ib-tws" (
    builtins.readFile ../../../pkgs/ib-tws/update.sh
  );
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

  # environment.systemPackages = [ update-ib-tws.update-ib-tws ];

  systemd.services."system-auto-build" = {
    path = [
      pkgs.nix
      pkgs.git
      pkgs.curl
      pkgs.gnused
      updateIbTws
    ];
    script = ''
      nix flake update --flake ${homeDir}/.dotfiles/
      update-ib-tws ${homeDir}/.dotfiles/pkgs/ib-tws
      nix build --option cores 1 "${homeDir}/.dotfiles#nixosConfigurations.${hostname}.config.system.build.toplevel" -o ${homeDir}/.dotfiles/build_updates
    '';
    serviceConfig = {
      Type = "simple";
      User = "${username}";
    };
  };
}
