{
  wayland.windowManager.hyprland.settings = {
    # Example windowrule
    # windowrule = float, ^(kitty)$

    windowrule = [
      "opacity 0.97 override 0.93 override,title:^(.*Emacs.*|.*Alacritty.*)$"
      "opacity 0.97 override 0.93 override,class:^(Alacritty)$"

      "maximize,class:^(firefox|librewolf|WebCord|Element|org.telegram.desktop|signal)$"
      "maximize,title:^(.*Mint-XFCE.*)"
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      "float, title:^(alacritty_float)$"
      "float, title:^(kitty_float)$"

      "workspace name:Social silent,class:^(WebCord|Element|org.telegram.desktop|signal)$"
      "workspace name:Web silent,class:^(firefox|librewolf)$"
      "workspace name:Mail silent,title:^(.*mu4e.*)"
      "workspace name:Action silent,class:^(install4j-jclient-LoginFrame)$"
      "workspace name:Charts silent,class:TradingView"
    ];

    # Workspace binding
    workspace = [
      # "name:Scanners,monitor:desc:Dell Inc. DELL S2425H FZM8M04,default:true"
    ];
  };
}
