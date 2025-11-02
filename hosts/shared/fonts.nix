{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    font-awesome
    material-icons
    material-design-icons
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    hack-font
  ];

  fonts.fontDir.enable = true;
}
