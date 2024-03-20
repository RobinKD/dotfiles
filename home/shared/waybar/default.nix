{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.hm-modules.waybar;
  nix-wayland-waybar = inputs.nixpkgs-wayland.packages.${pkgs.system}.waybar;
  check-updates = ../../../scripts/check_updates.sh;

in with lib; {
  options.hm-modules.waybar = { enable = mkEnableOption "waybar"; };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar.override { wireplumberSupport = false; };
      # TODO Config
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 60;
          # output = [ "*" ];
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "custom/nixos-updates"
            "tray"
            "network"
            "pulseaudio"
            "backlight"
            "battery"
            "clock"
          ];

          "custom/nixos-updates" = {
            exec = "${check-updates}";
            return-type = "json";
            interval = 300;
            format = "{icon}  {}";
            format-icons = "";
            tooltip = true;
          };

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{name}{windows}";
            tooltip = false;
            # format-icons = {
            #   active = "";
            #   default = "";
            #   empty = "󰧵 ";
            #   persistent = "󰧵 ";
            # };
            window-rewrite-default = ".";
            format-window-separator = "";
            # window-rewrite = {
            #   "title<.*youtube.*>" =
            #     ""; # Windows whose titles contain "youtube"
            #   "class<firefox>" = ""; # Windows whose classes are "firefox"
            #   "class<firefox> title<.*github.*>" =
            #     ""; # Windows whose class is "firefox" and title contains "github". Note that "class" always comes first.
            #   alacritty = "";
            #   emacs = "";
            #   dolphin = "";
            #   webcord = "󰙯";
            #   element = "";
            # };
          };

          "hyprland/window" = {
            format = "{class} {title}";
            rewrite = {
              "firefox (.*) — Mozilla Firefox" = " $1";
              "librewolf (.*) — LibreWolf" = " $1";
              "emacs (.*)" = " $1";
              "Alacritty (.*)" = " [$1]";
              ".*nemo (.*)" = " $1";
              ".*WebCord - (.*)" = "󰙯 $1";
              ".*Element.*" = " Element";
            };
            separate-outputs = true;
          };

          clock = { format = "{:%H:%M} "; };

          backlight = {
            device = "intel_backlight";
            format = "{percent}% {icon}";
            format-icons = [ "" "" "" "" "" "" "" "" "" ];
            tooltip = false;
          };

          pulseaudio = {
            format = "{volume}% {icon}";
            format-muted = "";
            tooltip = true;
            format-icons = {
              headphone = "";
              default = [ "" "" "󰕾" "󰕾" "󰕾" "" "" "" ];
            };
            scroll-step = 1;
          };

          network = {
            format = "{ifname}";
            format-wifi = "";
            format-ethernet = "";
            format-disconnected = "󰖪";
            tooltip-format-wifi = ''
              {essid} ({signalStrength}%)
              Connected with IP: {ipaddr}
              Upspeed: {bandwidthUpBits}
              Downspeed: {bandwidthDownBits}'';
            tooltip-format-ethernet = ''
              Connected with IP: {ipaddr}
              Upspeed: {bandwidthUpBits}
              Downspeed: {bandwidthDownBits}'';
            tooltip-format-disconnected = "Disconnected";
            on-click = "networkmanager_dmenu";
          };

          battery = {
            format = "{capacity}% {icon}";
            format-icons = [ "" "" "" "" "" ];
            format-charging = "{capacity}%";
            tooltip = false;
          };

          tray = { spacing = 10; };
        };
      };
      style = ''
        * {
          border: none;
          font-family: 'Fira Code', 'Symbols Nerd Font Mono';
          font-size: 16px;
          font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
          min-height: 45px;
        }

        window#waybar {
          background: transparent;
        }

        #workspaces, #window {
          border-radius: 10px;
          background-color: rgba(17,17, 27, 0.5);
          color: #b4befe;
          margin-top: 5px;
          margin-right: 15px;
          padding-top: 1px;
          padding-left: 10px;
          padding-right: 10px;
        }

        /* make window module transparent when no windows present */
        window#waybar.empty #window {
          background-color: transparent;
        }

        #workspaces button {
          color: #b4befe;
        }

        #workspaces button.visible {
          color: #5cd4ff;
        }

        #workspaces button.active {
          color: #cb5cff;
        }

        #workspaces button:hover {
          background:  rgba(75,175, 175, 0.5);
          box-shadow: none; /* Remove predefined box-shadow */
          text-shadow: none; /* Remove predefined text-shadow */
          transition: none; /* Disable predefined animations */
        }

        #clock, #backlight, #pulseaudio, #network, #battery, #tray, #custom-nixos-updates {
          border-radius: 10px;
          background-color: rgba(17, 17, 27, 0.5);
          color: #b4befe;
          margin-top: 5px;
          padding-left: 10px;
          padding-right: 10px;
        }

        #clock {
          margin-right: 0;
        }

      '';
    };
  };
}
