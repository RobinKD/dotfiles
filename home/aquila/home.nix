# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, config, lib, pkgs, ... }:

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
    ssh.enable = true;
    gpg.enable = true;
    firefox.enable = true;
    bash.enable = true;
    gtk-theme.enable = true;

    # Specific desktop modules
    hyprland.enable = true;
    dunst.enable = true;
    rofi.enable = true;
    autorandr.enable = true;
    polybar.enable = true;
    waybar.enable = true;

    # Useful
    pass.enable = true;

    # dev
    dev-languages = {
      python.enable = true;
      python_gpu.enable = true;
      latex.enable = true;
      # web.enable = true;
    };
    # Other
    conky.enable = true;
  };

  # Set your username

  home = {
    username = lib.mkDefault "keanu";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "22.11";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  wayland.windowManager.hyprland.settings.monitor =
    lib.mkIf hm-modules.hyprland.enable [
      "DP-1,1920x1080,-1920x0,1"
      "eDP-1,2560x1440@165,0x0,1.6"
      "HDMI-A-1,1920x1080,1599x0,1"
      "DP-2,1920x1080@60,1599x0,1"
    ];
}
