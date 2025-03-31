{
  wayland.windowManager.hyprland.settings = {
    # Example windowrule v1
    # windowrule = float, ^(kitty)$

    windowrule = [
      "opacity 0.97 override 0.93 override,title:^(.*Emacs.*|.*Alacritty.*)$"
      "opacity 0.97 override 0.93 override,class:^(Alacritty)$"

      "maximize,class:^(firefox|librewolf|WebCord|Element)$"
      "maximize,title:^(.*Mint-XFCE.*)"
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      "float, title:^(alacritty_float)$"
      "float, title:^(kitty_float)$"

      "workspace name:Social silent,class:^(WebCord|Element)$"
      "workspace name:Web silent,class:^(firefox|librewolf)$"
      "workspace name:Mail silent,title:^(.*mu4e.*)"
      "workspace name:Scanners silent,title:^(.*Screener.*)"
      "workspace name:Charts silent,title:^(.*Chart.*)"
    ];

    # Workspace binding
    workspace = [
      "name:Scanners, persistent:true, monitor:desc:Dell Inc. DELL S2425H FZM8M04,default:true"
      "name:Charts, persistent:true"
      "name:Action, persistent:true"
      "name:Web, persistent:true"
    ];
  };
}
