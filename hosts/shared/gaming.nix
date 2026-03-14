{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  hm = config.home-manager.users.keanu;
  homeDir = hm.home.homeDirectory;
  dotDir = "${homeDir}/.dotfiles";
in
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    protontricks.enable = true;
  };

  programs.gamemode = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    wineWow64Packages.stable
    winetricks
    wineWow64Packages.waylandFull
  ];
}
