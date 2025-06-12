{
  config,
  pkgs,
  lib,
  ...
}:
let
  sound_file = ./birds-chirping.mp3;
  username = config.home-manager.users.keanu.home.username;
in
{
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
