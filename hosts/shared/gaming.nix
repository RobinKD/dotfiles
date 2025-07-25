{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.gamemode = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    winetricks
    wineWowPackages.waylandFull
  ];
}
