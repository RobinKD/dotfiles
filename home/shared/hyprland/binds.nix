{ config, pkgs, ... }:
let
  screenshotarea = "hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copysave area; hyprctl keyword animation 'fadeOut,1,4,default'";

  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  # Would work with a QWERTY keyboard
  # workspaces = builtins.concatLists (builtins.genList (x:
  #   let ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
  #   in [
  #     "$mod, ${ws}, workspace, ${toString (x + 1)}"
  #     "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
  #   ]) 10);
  start-trading-day = pkgs.writeShellScriptBin "start-trading" ''
    tradingview & sleep 5; hyprctl dispatch moveworkspacetomonitor Charts desc:Dell Inc. DELL S2425H FZM8M04 &
    tws & sleep 5; hyprctl dispatch moveworkspacetomonitor Action desc:Beihai Century Joint Innovation Technology Co.Ltd QMC-VA30-02 0000000000000 &
    librewolf & firefox & sleep 5; hyprctl dispatch moveworkspacetomonitor Web desc:ASUSTek COMPUTER INC ASUS VA24EQSB S9LMTF185712 &
    sleep 5; restart-emacs; sleep 1; emacsclient -c -a emacs --eval '(org-roam-node-find)' & sleep 2; hyprctl dispatch focuswindow class:emacs; hyprctl dispatch movetoworkspace 1; hyprctl dispatch movewindow mon:desc:ASUSTek COMPUTER INC ASUS VA24EQSB S9LMTF185712;
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
      "$mod ALT, X, exec, loginctl kill-session $XDG_SESSION_ID"
      "$mod ALT, L, exec, hyprlock-random"
      "$mod ALT, Z, exec, systemctl suspend"
      "$mod ALT, P, exec, shutdown now"

      # Window Management
      "$mod, V, togglefloating,"
      "$mod SHIFT, R, exec, pkill waybar; hyprctl reload; waybar &"
      "$mod, R, exec, rofi-launcher"
      "$mod, TAB, exec, rofi-windows"
      "$mod, F, fullscreen, 0 # Fullscreen"
      "$mod, M, fullscreen, 1 # Maximize"
      "$mod SHIFT, F, togglefloating,"
      # "$mod, A, hyprexpo:expo, toggle" # can be: toggle, off/disable or on/enable
      # Change split mode for dwindle layout
      "$mod, D, togglesplit,"

      # Apps
      "$mod, Return, exec, alacritty"
      "$mod SHIFT, Return, exec, alacritty -T alacritty_float"
      "$mod, C, exec, conky"
      "$mod SHIFT, C, exec, pkill conky"
      "$mod, Q, killactive,"
      "$mod, E, exec, emacsclient -c -a emacs"
      "$mod, W, exec, networkmanager_dmenu"
      "$mod, K, exec, start-trading"

      # screenshot
      # stop animations while screenshotting; makes black border go away
      ", Print, exec, ${screenshotarea}"
      # Obs recording
      "$mod SHIFT, KP_multiply, exec, obs-cmd recording toggle"

      # Move focus with mm + arrow keys
      "$mod, left, workspace, e-1"
      "$mod, right, workspace, e+1"
      "$mod, up, cyclenext,"
      "$mod, down, cyclenext, prev"

      # Move active window with mm SHIFT + arrow keys
      "$mod SHIFT, left, movetoworkspace, r-1"
      "$mod SHIFT, right, movetoworkspace, r+1"
      "$mod SHIFT, up, swapnext,"
      "$mod SHIFT, down, swapnext, prev"

      # Scroll through existing workspaces on same monitor with mm + j/k
      "$mod, J, workspace, m-1"
      "$mod, K, workspace, m+1"
      # And create them if necessary
      "$mod, N, workspace, empty"

      # Scroll through existing workspaces with mm + scroll
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"

      # Multiple monitors
      "$mod, L, focusmonitor, -1"
      "$mod, H, focusmonitor, +1"

      # Move workspace to monitor
      "$mod SHIFT, L, movecurrentworkspacetomonitor, +1"
      "$mod SHIFT, H, movecurrentworkspacetomonitor, -1"

      # Switch workspaces with mm + [0-9]
      "$mod, ampersand, workspace, name:Action"
      "$mod, eacute, workspace, name:Charts"
      "$mod, quotedbl, workspace, name:Web"
      "$mod, apostrophe, workspace, name:Social"
      "$mod, parenleft, workspace, 1"
      "$mod, minus, workspace, 2"
      "$mod, egrave, workspace, 3"
      "$mod, underscore, workspace, 4"
      "$mod, ccedilla, workspace, 5"
      "$mod, agrave, workspace, previous"

      # Move active window to a workspace with mm + SHIFT + [1-9]
      "$mod SHIFT, ampersand, movetoworkspace, name:Action"
      "$mod SHIFT, eacute, movetoworkspace, name:Charts"
      "$mod SHIFT, quotedbl, movetoworkspace, name:Web"
      "$mod SHIFT, apostrophe, movetoworkspace, name:Social"
      "$mod SHIFT, parenleft, movetoworkspace, 1"
      "$mod SHIFT, minus, movetoworkspace, 2"
      "$mod SHIFT, egrave, movetoworkspace, 3"
      "$mod SHIFT, underscore, movetoworkspace, 4"
      "$mod SHIFT, ccedilla, movetoworkspace, 5"
      "$mod SHIFT, N, movetoworkspace, empty"
    ];

    binde = [
      # Repeatable keypresses
      # Brightness, audio
      ", XF86MonBrightnessDown, exec, brightnessctl s 1%-"
      ", XF86MonBrightnessUp, exec, brightnessctl s 1%+"
      ", XF86AudioMute, exec, amixer set Master toggle"
      ", XF86AudioMicMute, exec, amixer set Capture toggle"
      ", XF86AudioRaiseVolume, exec, amixer set Master 1%+"
      ", XF86AudioLowerVolume, exec, amixer set Master 1%-"
    ];

    bindm = [
      # Mouse keybinds
      # Move/resize windows with mm + LMB/RMB and dragging
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
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
