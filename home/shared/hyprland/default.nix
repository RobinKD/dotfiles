{
  inputs,
  config,
  lib,
  pkgs,
  wallpapers,
  ...
}:
let
  hmm = config.hm-modules;
  cfg = config.hm-modules.hyprland;
  hyprcontrib = inputs.hyprwm-contrib.packages.${pkgs.stdenv.hostPlatform.system};
  nix-wayland = inputs.nixpkgs-wayland.packages.${pkgs.stdenv.hostPlatform.system};
in
with lib;
{
  options.hm-modules.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  imports = [
    ./settings.nix
    ./rules.nix
    ./binds.nix
    ./nightshift.nix
    ./hyprlock.nix
    ./hyprpaper.nix
  ];

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hmm.waybar.enable;
        message = "Waybar not enabled for hyprland";
      }
      {
        assertion = hmm.rofi.enable;
        message = "Rofi not enabled for hyprland";
      }
      {
        assertion = hmm.dunst.enable;
        message = "Dunst not enabled for hyprland, you won't get notifications";
      }
    ];

    home.packages =
      (with pkgs; [
        conky
        nagiosPlugins.check_uptime
        libsForQt5.qt5ct
        slurp
        libsForQt5.qtwayland
        hyprcontrib.grimblast
        # hyprcontrib.try_swap_workspace # pgrep -x not working
        hyprcontrib.scratchpad
      ])
      ++ (with nix-wayland; [
        grim
        wl-clipboard
        wf-recorder
      ]);

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      systemd.enable = false;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      # plugins = [
      #   inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
      # ];
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "hyprlock-random";
          lock_cmd = "hyprlock-random";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock-random";
          }
        ];
      };
    };

    # # Seems to make screen sharing impossible
    # xdg.portal = {
    #   enable = true;
    #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    #   config = { common = { default = [ "hyprland" "gtk" ]; }; };
    # };
  };
}
