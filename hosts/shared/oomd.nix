{ pkgs, ... }:

{

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 35;
    freeMemKillThreshold = 2;
    freeSwapKillThreshold = 25;
    # Prefer killing the process with the highest OOM score (usually the game)
    enableNotifications = true; # shows a desktop notification before kill
    extraArgs = [
      "-g"
      "--prefer"
      "exe$"
      "--avoid"
      "^(Hyprland|.*ypr.*)$"
    ];
  };

  systemd.oomd = {
    enable = true;
    enableRootSlice = true; # monitor everything
    enableUserSlices = true; # monitor per-user slices (good for games)
    settings.OOM = {
      DefaultMemoryPressureLimit = "90%"; # act at 70% pressure
      SwapUsedLimit = "70%"; # or when swap is half used
    };
  };
}
