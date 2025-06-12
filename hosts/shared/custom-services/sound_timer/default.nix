{
  config,
  pkgs,
  lib,
  ...
}:
let
  sound_file = ./birds-chirping.mp3;
  username = config.home-manager.users.keanu.home.username;
  trading_wakeup = pkgs.writeShellScriptBin "trading_wakeup" ''
    is_active=$(systemctl is-active --user trading_wakeup.timer)
    if [ $is_active == "active" ]; then
      echo "Systemd service active, stopping..."
      systemctl stop --user trading_wakeup.timer
    else
      echo "Systemd service inactive, starting..."
      systemctl start --user trading_wakeup.timer
    fi
  '';
in
{

  environment.systemPackages = [ trading_wakeup ];
  systemd.user.timers."trading_wakeup" = {
    wantedBy = lib.mkForce [ ];
    timerConfig = {
      OnCalendar = "*:*:10";
      AccuracySec = "1s";
      Unit = "trading_wakeup.service";
    };
  };

  systemd.user.services."trading_wakeup" = {
    path = [
      pkgs.pulseaudio
    ];
    script = ''
      paplay ${sound_file}
    '';
    serviceConfig = {
      Type = "simple";
    };
  };
}
