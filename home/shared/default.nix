{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./firefox
    ./emacs

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
    ./ssh

    # Useful
    ./pass

    # dev
    ./dev

    # Other
    ./conky
    ./nightshift
  ];

  home.packages = with pkgs; [
    font-manager
    discord
    element-desktop
  ];

  programs.nix-index = {
    enable = true;
  };

  # Make sure enchant picks up correct aspell dir
  home.file.".aspell.conf" = {
    enable = true;
    text = "dict-dir /run/current-system/etc/profiles/per-user/${config.home.username}/lib/aspell/";
  };

}
