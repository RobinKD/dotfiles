{
  config,
  pkgs,
  lib,
  ...
}:
let
  screenshot = "shader=$(hyprshade current) && hyprshade off && hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copysave active; hyprctl keyword animation 'fadeOut,1,4,default' && hyprshade on $shader";
  copyarea = "shader=$(hyprshade current) && hyprshade off && hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copy area; hyprctl keyword animation 'fadeOut,1,4,default' && hyprshade on $shader";

  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  # Would work with a QWERTY keyboard
  # workspaces = builtins.concatLists (builtins.genList (x:
  #   let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
  #   in [
  #     "$mod, ${ws}, workspace, ${toString (x + 1)}"
  #     "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
  #   ]) 10);
  start-trading-day = pkgs.writeShellScriptBin "start-trading" ''
    tradingWakeup & tws & librewolf & firefox &
  '';
in
{
  home.packages = [ start-trading-day ];

  wayland.windowManager.hyprland.settings = {

    # bindl = [
    #   ''
    #     , switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1, 2560x1440, 0x0, 1.6"''
    #   '', switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1, disable"''
    # ];

    # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    #
    bind = [
      # System
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + ALT + X"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("loginctl kill-session $XDG_SESSION_ID")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + ALT + L"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("hyprlock-random")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + ALT + Z"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("systemctl suspend")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + ALT + P"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("shutdown now")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + R"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pkill waybar; hyprctl reload; waybar &")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + R"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("rofi-launcher")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + TAB"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("rofi-windows")'')
        ];
      }

      # Window Management
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + F"'')
          (lib.generators.mkLuaInline ''hl.dsp.window.fullscreen({mode = "fullscreen"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + M"'')
          (lib.generators.mkLuaInline ''hl.dsp.window.fullscreen({mode = "maximized"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + F"'')
          (lib.generators.mkLuaInline "hl.dsp.window.float()")
        ];
      }
      # "$mod, A, hyprexpo:expo, toggle" # can be: toggle, off/disable or on/enable
      # Change split mode for dwindle layout
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + D"'')
          (lib.generators.mkLuaInline ''hl.dsp.layout("togglesplit")'')
        ];
      }

      # Apps
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + RETURN"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("alacritty")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + RETURN"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("alacritty -T alacritty_float")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + C"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("conky")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + C"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pkill conky")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + Q"'')
          (lib.generators.mkLuaInline "hl.dsp.window.close()")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + Q"'')
          (lib.generators.mkLuaInline "hl.dsp.window.kill()")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + E"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("emacsclient -c -a emacs")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + W"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("networkmanager_dmenu")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + K"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("start-trading")'')
        ];
      }

      # screenshot
      # stop animations while screenshotting; makes black border go away
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + S"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${screenshot}")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + CTRL + S"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${copyarea}")'')
        ];
      }

      # Move focus with mm + arrow keys
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + left"'')
          (lib.generators.mkLuaInline ''hl.dsp.focus({workspace = "e-1"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + right"'')
          (lib.generators.mkLuaInline ''hl.dsp.focus({workspace = "e+1"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + up"'')
          (lib.generators.mkLuaInline ''hl.dsp.layout("cyclenext")'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + down"'')
          (lib.generators.mkLuaInline ''hl.dsp.layout("cycleprev")'')
        ];
      }

      # Move active window with mm SHIFT + arrow keys
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + left"'')
          (lib.generators.mkLuaInline ''hl.dsp.window.move({workspace = "r-1"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + right"'')
          (lib.generators.mkLuaInline ''hl.dsp.window.move({workspace = "r+1"})'')
        ];
      }

      # Scroll through existing workspaces on same monitor with mm + j/k
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + J"'')
          (lib.generators.mkLuaInline ''hl.dsp.focus({workspace = "m-1"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + K"'')
          (lib.generators.mkLuaInline ''hl.dsp.focus({workspace = "m+1"})'')
        ];
      }
      # And create them if necessary
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + N"'')
          (lib.generators.mkLuaInline ''hl.dsp.focus({workspace = "empty"})'')
        ];
      }

      # Multiple monitors
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + L"'')
          (lib.generators.mkLuaInline ''hl.dsp.focus({monitor = "-1"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + H"'')
          (lib.generators.mkLuaInline ''hl.dsp.focus({monitor = "+1"})'')
        ];
      }

      # Move workspace to monitor
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + L"'')
          (lib.generators.mkLuaInline ''hl.dsp.workspace.move({monitor = "-1"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + H"'')
          (lib.generators.mkLuaInline ''hl.dsp.workspace.move({monitor = "+1"})'')
        ];
      }

      # Switch workspaces with mm + [0-9]
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + 1"'')
          (lib.generators.mkLuaInline ''hl.dsp.focus({workspace = "name:Action"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + 2"'')
          (lib.generators.mkLuaInline ''hl.dsp.focus({workspace = "name:Charts"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + 3"'')
          (lib.generators.mkLuaInline ''hl.dsp.focus({workspace = "name:Web"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + 4"'')
          (lib.generators.mkLuaInline ''hl.dsp.focus({workspace = "name:Social"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + 5"'')
          (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 1})")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + 6"'')
          (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 2})")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + 7"'')
          (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 3})")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + 8"'')
          (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 4})")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + 9"'')
          (lib.generators.mkLuaInline "hl.dsp.focus({workspace = 5})")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + 0"'')
          (lib.generators.mkLuaInline ''hl.dsp.focus({workspace = "previous"})'')
        ];
      }

      # Move active window to a workspace with mm + SHIFT + [1-9]
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + 1"'')
          (lib.generators.mkLuaInline ''hl.dsp.window.move({workspace = "name:Action"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + 2"'')
          (lib.generators.mkLuaInline ''hl.dsp.window.move({workspace = "name:Charts"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + 3"'')
          (lib.generators.mkLuaInline ''hl.dsp.window.move({workspace = "name:Web"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + 4"'')
          (lib.generators.mkLuaInline ''hl.dsp.window.move({workspace = "name:Social"})'')
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + 5"'')
          (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 1})")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + 6"'')
          (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 2})")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + 7"'')
          (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 3})")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + 8"'')
          (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 4})")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + 9"'')
          (lib.generators.mkLuaInline "hl.dsp.window.move({workspace = 5})")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + SHIFT + N"'')
          (lib.generators.mkLuaInline ''hl.dsp.window.move({workspace = "empty"})'')
        ];
      }

      # Repeatable keypresses
      # Brightness, audio
      {
        _args = [
          "XF86MonBrightnessDown"
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("brightnessctl s 1%-")'')
          (lib.generators.mkLuaInline "{repeating = true}")
        ];
      }
      {
        _args = [
          "XF86MonBrightnessUp"
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("brightnessctl s 1%+")'')
          (lib.generators.mkLuaInline "{repeating = true}")

        ];
      }
      {
        _args = [
          "XF86AudioMute"
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("amixer set Master toggle")'')
          (lib.generators.mkLuaInline "{repeating = true}")

        ];
      }
      {
        _args = [
          "XF86AudioMicMute"
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("amixer set Capture toggle")'')
          (lib.generators.mkLuaInline "{repeating = true}")

        ];
      }
      {
        _args = [
          "XF86AudioRaiseVolume"
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("amixer set Master 1%+")'')
          (lib.generators.mkLuaInline "{repeating = true}")

        ];
      }
      {
        _args = [
          "XF86AudioLowerVolume"
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("amixer set Master 1%-")'')
          (lib.generators.mkLuaInline "{repeating = true}")

        ];
      }

      # Mouse keybinds
      # Move/resize windows with mm + LMB/RMB and dragging
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + mouse:272"'')
          (lib.generators.mkLuaInline "hl.dsp.window.drag()")
          (lib.generators.mkLuaInline "{ mouse = true }")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline ''mod .. " + mouse:273"'')
          (lib.generators.mkLuaInline "hl.dsp.window.resize()")
          (lib.generators.mkLuaInline "{ mouse = true }")
        ];
      }
    ];

    # plugin = {
    #   hyprexpo = {
    #     columns = 3;
    #     gap_size = 8;
    #     bg_col = "rgba(111111aa)";
    #     workspace_method = "center current";
    #   };
    # };
  };
}
