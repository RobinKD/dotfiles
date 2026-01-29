{
  inputs,
  config,
  pkgs,
  wallpapers,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "true";
      splash = "false";
    };
  };
}
