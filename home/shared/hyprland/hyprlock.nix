{
  inputs,
  config,
  lib,
  pkgs,
  wallpapers,
  ...
}:
let
  hmm = config.hm-modules;
  cfg = config.hm-modules.hyprland;
  hyprlock-random = pkgs.writeShellScriptBin "hyprlock-random" ''
    ${pkgs.coreutils}/bin/cp `${pkgs.findutils}/bin/find ${wallpapers} -type f | ${pkgs.coreutils}/bin/shuf -n 1` /tmp/background.jpg
    wait &&
    hyprlock
  '';
  hyprlock-package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
in
{
  security.pam.services.hyprlock = { };

  home.packages = [
    hyrplock-random
  ];

  programs.hyprlock = {
    enable = true;
    package = hyprlock-package;
    settings = {
      general = {
        disable_loading_bar = false;
        hide_cursor = false;
        grace = 0;
        ignore_empty_input = false;
        text_trim = true;
        fractional_scaling = 2;
        screencopy_mode = 0;
      };
      auth = {
        "pam:enabled" = true;
      };
      background = [
        {
          path = "/tmp/background.jpg";
          blur_passes = 1;
        }
      ];
      image = {
        path = "${wallpapers}/tarentula-3.jpg";
        size = 300;
        rounding = -1;
        border_size = 0;
        border_color = "rgba(255, 255, 255, 0.85)";
        position = "0, 100";
      };
      input-field = {
        size = "600, 100";
        outline_thickness = 4;
        position = "0, -200";
        dots_rounding = 4;
        font_color = "rgba(240,240,240,1.0)";
        inner_color = "rgba(120,120,120,0.15)";
        outer_color = "rgba(255,255,255,0.85)";
        fail_color = "rgba(255,255,255,0.85)";
        placeholder_text = "<i>...</i>";
        rounding = 12;
        check_color = "rgba(0,0,5,1)";
      };
      label = [
        {
          text = ''cmd[update:1000] echo "<span>$(date "+%H:%M:%S")</span>"'';
          font_size = 30;
          font_family = "Hack";
          halign = "center";
          valign = "center";
          position = "0,300";
        }
        {
          text = ''cmd[update:1000] echo "<span>$(date "+%A, %B %d")</span>"'';
          font_size = 40;
          font_family = "Hack";
          halign = "center";
          valign = "center";
          position = "0,360";
        }
      ];
    };
  };
}
