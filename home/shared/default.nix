{ pkgs, ... }: {
  imports = [
    # GUI
    ./firefox

    ./hyprland
    ./dunst
    ./polybar # TODO Separate from leftwm
    ./rofi
    ./waybar
    ./autorandr
    ./leftwm
    # ./eww
    ./gtk-theme

    # cli
    ./direnv
    ./git
    ./gpg
    ./bash

    # Useful
    ./pass

    # dev
    ./dev

    # Other
    ./conky
  ];

  home.packages = with pkgs; [ font-manager discord element-desktop ];

  programs.nix-index = { enable = true; };
  services.flameshot = { enable = true; };

  # Make sure enchant picks up correct aspell dir
  home.file.".aspell.conf" = {
    enable = true;
    text = "dict-dir /run/current-system/sw/lib/aspell/";
  };
}
