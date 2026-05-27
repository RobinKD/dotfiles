{
  wayland.windowManager.hyprland.settings = {
    # Example windowrule
    # windowrule = float, ^(kitty)$

    window_rule = [
      {
        name = "transparent-emacs-terminal";
        match = {
          class = "^(.*emacs.*|.*Alacritty.*)$";
        };
        opacity = "0.97 override 0.93 override";
      }
      {
        name = "maximizedApps";
        match = {
          class = "^(firefox|librewolf|WebCord|Element|org.telegram.desktop|signal)$";
        };
        maximize = true;
      }
      {
        name = "alwaysFloat";
        match = {
          title = "^(Picture-in-Picture|alacritty_float)$";
        };
        float = true;
      }
      {
        name = "PinPiP";
        match = {
          title = "^(Picture-in-Picture)$";
        };
        pin = true;
      }
      {
        name = "pinLogs";
        match = {
          class = "^(Loa-logs)$";
        };
        pin = true;
      }
      {
        name = "floatLogs";
        match = {
          class = "^(Loa-logs)$";
        };
        float = true;
      }
      {
        name = "noBorderFloat";
        match = {
          float = true;
          focus = false;
        };
        border_size = 0;
      }
      {
        name = "socialApps";
        match = {
          class = "^(WebCord|Element|org.telegram.desktop|signal)$";
        };
        workspace = "name:Social silent";
      }
      {
        name = "webApps";
        match = {
          class = "^(firefox|librewolf)$";
        };
        workspace = "name:Web silent";
      }
      {
        name = "chartsApps";
        match = {
          class = "TradingView";
        };
        workspace = "name:Charts silent";
      }
    ];

    # Workspace binding
    workspace = [
      # "name:Scanners,monitor:desc:Dell Inc. DELL S2425H FZM8M04,default:true"
    ];
  };
}
