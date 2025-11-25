{ pkgs, ... }:

{

  services.earlyoom = {
    enable = true;
    # Start killing when free memory + swap drops below 10% (default)
    freeMemThreshold = 15;
    # Prefer killing the process with the highest OOM score (usually the game)
    preferRegex = ".*"; # default, kills worst offender
    ignoreRootUser = true; # optional, don’t kill root processes
    enableNotifications = true; # shows a desktop notification before kill
  };

  # Optional: also show a GUI notification (requires a desktop environment)
  services.earlyoom.enableNotifications = true;

  systemd.oomd = {
    enable = true;
    enableRootSlice = true; # monitor everything
    enableUserSlices = true; # monitor per-user slices (good for games)
    extraConfig = {
      DefaultMemoryPressureLimit = "70%"; # act at 70% pressure
      DefaultSwapPressureLimit = "50%"; # or when swap is half used
    };
  };
}
