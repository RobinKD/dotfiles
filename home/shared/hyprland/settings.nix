{
  inputs,
  lib,
  pkgs,
  wallpapers,
  ...
}:
let
  set-background = pkgs.writeShellScriptBin "set-background" ''
    WALLPAPER=$(${pkgs.findutils}/bin/find ${wallpapers} -type f | ${pkgs.coreutils}/bin/shuf -n 1)
    hyprctl hyprpaper wallpaper ,$WALLPAPER
  '';
in
{
  home.packages = [ set-background ];
  wayland.windowManager.hyprland = {
    configType = "lua"; # TODO Remove when 26.05 out
    # plugins = [
    #   inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
    # ];
    settings = {
      mod._var = "SUPER";

      env = [
        {
          _args = [
            "LIBSEAT_BACKEND"
            "logind"
          ];
        }
        {
          _args = [
            "XCURSOR_SIZE"
            "24"
          ];
        }
        {
          _args = [
            "_JAVA_AWT_WM_NONREPARENTING"
            "1"
          ];
        }
        {
          _args = [
            "LIBVA_DRIVER_NAME"
            "nvidia"
          ];
        }
        {
          _args = [
            "__GLX_VENDOR_LIBRARY_NAME"
            "nvidia"
          ];
        }
        {
          _args = [
            "WLR_NO_HARDWARE_CURSORS"
            "1"
          ];
        }
        {
          _args = [
            "__GL_GSYNC_ALLOWED"
            "0"
          ];
        }
        {
          _args = [
            "__GL_VRR_ALLOWED"
            "2"
          ];
        }
        {
          _args = [
            "ELECTRON_OZONE_PLATFORM_HINT"
            "auto"
          ];
        }
      ];

      config = {
        general = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          gaps_in = 5;
          gaps_out = 5;
          border_size = 3;
          col = {
            active_border = {
              colors = [
                "rgba(33ccffee)"
                "rgba(00ff99ee)"
              ];
              angle = 45;
            };
            inactive_border = "rgba(595959aa)";
          };
          layout = "master"; # master | dwindle
        };
        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            new_optimizations = true;
          };
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
        };
        animations.enabled = true;
        input = {
          kb_layout = "us";
          kb_options = "compose:ralt";
          # kb_variant =
          # kb_model =
          # kb_rules =

          numlock_by_default = true;

          follow_mouse = 1;

          touchpad = {
            natural_scroll = false;
          };

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };
        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # you probably want this
          force_split = 2; # Split to the rigth
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_status = "slave";
        };

        misc = {
          on_focus_under_fullscreen = 1;
          focus_on_activate = false;
          disable_splash_rendering = true;
        };

        debug = {
          full_cm_proto = true; # For gaming
        };
      };

      monitor = [
        # See https://wiki.hyprland.org/Configuring/Monitors/
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];

      curve._args = [
        "myBezier"
        {
          type = "bezier";
          points = [
            [
              0.05
              0.9
            ]
            [
              0.1
              1.05
            ]
          ];
        }
      ];

      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 7;
          bezier = "myBezier";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 7;
          bezier = "myBezier";
          style = "popin 80%";
        }
        # {
        #   leaf = "fade";
        #   enabled = true;
        #   speed = 7;
        #   curve = "default";
        # }
        # {
        #   leaf = "workspaces";
        #   enabled = true;
        #   speed = 6;
        #   curve = "default";
        # }
      ];

      # plugin = {
      #   hyprexpo = {
      #     columns = 3;
      #     gap_size = 4;
      #     bg_col = "rgb(000000)";

      #     enable_gesture = true;
      #     gesture_distance = 300;
      #     gesture_positive = false;
      #   };
      # };
    };
  };
}
