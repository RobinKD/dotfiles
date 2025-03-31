{ lib, pkgs, ... }:
let
  set-background = pkgs.writeTextFile {
    name = "swww-set-background";
    destination = "/bin/swww-set-background";
    executable = true;
    text = "swww img `find ~/.dotfiles/wallpapers/ -type f | shuf -n 1`";
  };
in
{
  home.packages = [ set-background ];
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "sleep 1; waybar"
      "swww-daemon"
      "sleep 1; swww-set-background"
      "configure-gtk"
      "hyprctl setcursor Catppuccin-Mocha-Sapphire-Cursors 32"
    ];

    "$mod" = "SUPER";

    env = [
      "LIBSEAT_BACKEND,logind"
      "XCURSOR_SIZE,24"
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "_JAVA_AWT_WM_NONREPARENTING,1"
      "LIBVA_DRIVER_NAME,nvidia"
      # "GBM_BACKEND,nvidia-drm # crashes Hyprland"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "WLR_NO_HARDWARE_CURSORS,1"
      "__GL_GSYNC_ALLOWED,0"
      "__GL_VRR_ALLOWED,2"
      "ELECTRON_OZONE_PLATFORM_HINT,auto"
      # "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card2"
    ];

    monitor = [
      # See https://wiki.hyprland.org/Configuring/Monitors/
      ",preferred,auto,auto"
    ];

    general = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      gaps_in = 5;
      gaps_out = 5;
      border_size = 3;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";

      layout = "dwindle"; # master | diwndle
    };

    input = {
      kb_layout = "fr";
      # kb_variant =
      # kb_model =
      # kb_options =
      # kb_rules =

      numlock_by_default = true;

      follow_mouse = 1;

      touchpad = {
        natural_scroll = "no";
      };

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
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

    animations = {
      enabled = "yes";

      # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    dwindle = {
      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      pseudotile = "yes";
      preserve_split = "yes"; # you probably want this
      force_split = 2; # Split to the rigth
    };

    master = {
      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      new_status = "master";
    };

    gestures = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      workspace_swipe = "off";
    };
  };
}
