{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    font-awesome
    material-icons
    material-design-icons
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
        "SourceCodePro"
        "Iosevka"
        "JetBrainsMono"
      ];
    })
    hack-font
  ];

  fonts.fontDir.enable = true;
}
