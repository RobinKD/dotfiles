{
  wayland.windowManager.hyprland.settings = {
    # Example windowrule
    # windowrule = float, ^(kitty)$

    windowrule = [
      "opacity 0.97 override 0.93 override,match:title ^(.*Emacs.*|.*Alacritty.*)$"
      "opacity 0.97 override 0.93 override,match:class ^(Alacritty)$"

      "maximize on,match:class ^(firefox|librewolf|WebCord|Element|org.telegram.desktop|signal)$"
      "float on, match:title ^(Picture-in-Picture)$"
      "pin on, match:title ^(Picture-in-Picture)$"
      "float on, match:title ^(alacritty_float)$"
      "float on, match:title ^(kitty_float)$"

      "workspace name:Social silent,match:class ^(WebCord|Element|org.telegram.desktop|signal)$"
      "workspace name:Web silent,match:class ^(firefox|librewolf)$"
      "workspace name:Mail silent,match:title ^(.*mu4e.*)"
      "workspace name:Action silent,match:class ^(install4j-jclient-LoginFrame)$"
      "workspace name:Charts silent,match:class TradingView"
    ];

    # Workspace binding
    workspace = [
      # "name:Scanners,monitor:desc:Dell Inc. DELL S2425H FZM8M04,default:true"
    ];
  };
}
