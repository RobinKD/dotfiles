{
  inputs,
  config,
  pkgs,
  wallpapers,
  ...
}:
let
  hyprlock-random = pkgs.writeShellScriptBin "hyprlock-random" ''
    ${pkgs.coreutils}/bin/cp -f `${pkgs.findutils}/bin/find ${wallpapers} -type f | ${pkgs.coreutils}/bin/shuf -n 1` ${config.xdg.configHome}/hypr/background.jpg
    wait &&
    hyprlock
  '';
  hyprlock-package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
    };
  };
}
