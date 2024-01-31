{ config, lib, pkgs, ... }:
let
  hm = config.home-manager.users.keanu;
  hmm = hm.hm-modules;
  cfg = config.modules.desktop.hyprland;
  gtk-cfg = hmm.gtk-theme;
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme "${gtk-cfg.theme}"
      gsettings set $gnome_schema icon-theme "${gtk-cfg.icon-theme}"
      gsettings set $gnome_schema cursor-theme "${gtk-cfg.cursor-theme}"
      gsettings set $gnome_schema cursor-size "${gtk-cfg.cursor-size}"
      gsettings set $gnome_schema font-name "${gtk-cfg.font-name}"
    '';
  };
in with lib; {
  options.modules.desktop = { hyprland.enable = mkEnableOption "desktop"; };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = hmm.hyprland.enable;
      message = "Hyprland home-manager module not enabled";
    }];
    environment.systemPackages = [ pkgs.glib configure-gtk ];
    programs.hyprland = {
      enable = true;
      xwayland = { enable = true; };
    };
  };
}
