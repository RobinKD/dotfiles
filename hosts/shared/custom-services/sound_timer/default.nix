{
  config,
  pkgs,
  lib,
  ...
}:
let
  sound_file = ./birds-chirping.mp3;
  username = config.home-manager.users.keanu.home.username;
  trading_wakeup = pkgs.writeShellScriptBin "tradingWakeup" ''
    is_active=$(systemctl is-active --user tradingWakeup.timer)
    if [ $is_active == "active" ]; then
      echo "Systemd service active, stopping..."
      systemctl stop --user tradingWakeup.timer
    else
      echo "Systemd service inactive, starting..."
      systemctl start --user tradingWakeup.timer
    fi
  '';
in
{

  environment.systemPackages = [ trading_wakeup ];
  systemd.user.timers."tradingWakeup" = {
    wantedBy = lib.mkForce [ ];
    timerConfig = {
      OnCalendar = "*:0,30";
      AccuracySec = "1s";
      Unit = "tradingWakeup.service";
    };
  };

  systemd.user.services."tradingWakeup" = {
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
