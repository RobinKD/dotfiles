{ inputs, config, lib, pkgs, wallpapers, ... }:
let
  hmm = config.hm-modules;
  cfg = config.hm-modules.hyprland;
  hyprcontrib = inputs.hyprwm-contrib.packages.${pkgs.system};
  nix-wayland = inputs.nixpkgs-wayland.packages.${pkgs.system};
in with lib; {
  options.hm-modules.hyprland = {
    enable = mkEnableOption "hyprland";
    swaylock-effects = mkOption {
      type = types.str;
      description = "My effects for swaylock-effects";
      default =
        "-i `${pkgs.findutils}/bin/find ${wallpapers} -type f | ${pkgs.coreutils}/bin/shuf -n 1` --clock --indicator --indicator-radius 80 --indicator-thickness 3 --effect-blur 4x4 --effect-vignette 0.5:0.5 --ring-color 74bdf2 --key-hl-color bd2afc --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --fade-in 0.1 --inside-ver-color 00000088 --text-ver-color 74bdf2 --line-ver-color 74bdf2 --text-wrong-color ff0000 --inside-wrong-color 00000000 --line-wrong-color ff0000 --inside-clear-color 00000000 --line-clear-color 43f99e --text-clear-color 43f99e";
    };
  };

  imports = [ ./settings.nix ./rules.nix ./binds.nix ];

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

    home.packages = (with pkgs; [
      conky
      nagiosPlugins.check_uptime
      qt5ct
      webcord
      slurp
      libsForQt5.qtwayland
      inputs.hyprlock.packages.${pkgs.system}.hyprlock
      hyprcontrib.grimblast
      # hyprcontrib.try_swap_workspace # pgrep -x not working
      hyprcontrib.scratchpad
    ]) ++ (with nix-wayland; [
      grim
      wl-clipboard
      swayidle
      swaylock-effects
      swww
      wf-recorder
    ]);

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland = { enable = true; };
    };

    services.swayidle = {
      enable = true;
      package = nix-wayland.swayidle;
      systemdTarget = "hyprland-session.target";
      timeouts = let dpmsCommand = "hyprctl dispatch dpms";
      in [{
        timeout = 300;
        command =
          "${nix-wayland.swaylock-effects}/bin/swaylock ${cfg.swaylock-effects}";
      }
      # {
      #   timeout = 10;
      #   command = "${dpmsCommand} off";
      #   resumeCommand = "${dpmsCommand} on";
      # }
      ];
      events = [{
        event = "before-sleep";
        command =
          "${nix-wayland.swaylock-effects}/bin/swaylock ${cfg.swaylock-effects}";
      }];
    };

    # # Seems to make screen sharing impossible
    # xdg.portal = {
    #   enable = true;
    #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    #   config = { common = { default = [ "hyprland" "gtk" ]; }; };
    # };
  };
}
