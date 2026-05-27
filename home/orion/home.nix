# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:

rec {
  # You can import other home-manager modules here
  imports = [
    # Custom modules
    outputs.homeManagerModules

    # Modules
    ../shared
  ];

  hm-modules = {
    # Basically always true, but who knows...
    git.enable = true;
    gpg.enable = true;
    firefox.enable = true;
    librewolf.enable = true;
    bash.enable = true;
    gtk-theme.enable = true;
    ssh.enable = true;

    # Specific desktop modules
    hyprland.enable = true;
    dunst.enable = true;
    rofi.enable = true;
    # autorandr.enable = true;
    polybar.enable = true;
    waybar.enable = true;
    # eww.enable = true;

    # Useful
    pass.enable = true;

    # dev
    dev-languages = {
      python.enable = true;
      python_gpu.enable = false;
      latex.enable = true;
      web.enable = true;
    };

    # Other
    conky.enable = true;
    nightshift.enable = true;

  };

  # Set your username
  home = {
    username = lib.mkDefault "keanu";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "23.11";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  wayland.windowManager.hyprland.settings = {
    monitor = lib.mkIf hm-modules.hyprland.enable [
      {
        output = "desc:Beihai Century Joint Innovation Technology Co.Ltd QMC-VA30-02 0000000000000";
        mode = "2560x1080@165";
        position = "0x0";
        scale = 1;
      }
      {
        output = "desc:Dell Inc. DELL S2425H FZM8M04";
        mode = "1920x1080@60";
        position = "-1320x-1080";
        scale = 1;
      }
      {
        output = "desc:Samsung Electric Company C27F390 H4LR605458";
        mode = "1920x1080@60";
        position = "600x-1080";
        scale = 1;
      }

      {
        output = "desc:ASUSTek COMPUTER INC ASUS VA24EQSB S9LMTF185712";
        mode = "1920x1080@60";
        position = "-1080x0";
        scale = 1;
        transform = 1;
      }

    ];
    on._args = [
      "hyprland.start"
      (lib.generators.mkLuaInline ''
        function()
        hl.exec_cmd("sleep 1; waybar")
        hl.exec_cmd("sleep 10; set-background")
        hl.exec_cmd("sleep 5; restart-emacs")
        hl.exec_cmd("configure-gtk")
        hl.exec_cmd("hyprctl setcursor Catppuccin-Mocha-Sapphire-Cursors 32")
        hl.exec_cmd("xrandr --output HDMI-A-1 --primary")
        end
      '')
    ];
  };

  wayland.windowManager.hyprland.settings = {
    windowrule = [
      # "fullscreen,class:^(steam_app*)$"
      # "monitor:desc:Beihai Century Joint Innovation Technology Co.Ltd QMC-VA30-02 0000000000000,class:^(steam_app*)$"
    ];
  };
}
