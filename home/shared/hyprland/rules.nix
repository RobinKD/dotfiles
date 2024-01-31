{
  wayland.windowManager.hyprland.settings = {
    # Example windowrule v1
    # windowrule = float, ^(kitty)$

    windowrule = [
      "float,rofi"
      "opacity 0.97 override 0.93 override,title:^(.*Emacs.*|.*Alacritty.*)$"
      "opacity 0.97 override 0.93 override,class:^(Alacritty)$"
    ];

    # Example windowrule v2
    # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

    windowrulev2 = [
      "workspace name:Social silent,class:^(WebCord|Element)$"
      "workspace name:Web silent,class:^(firefox|librewolf)$"
      "workspace name:Mail silent,title:^(.*mu4e.*)"
      "maximize,class:^(firefox|librewolf|WebCord|Element)$"
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      "float, title:^(alacritty_float)$"
      "float, title:^(kitty_float)$"
    ];

    # Workspace binding
    workspace = [
      "name:Main, persistent:true"
      "name:Web, persistent:true"
      "name:Social, monitor:eDP-1"
      "name:Mail, monitor:eDP-1"
    ];
  };
}
