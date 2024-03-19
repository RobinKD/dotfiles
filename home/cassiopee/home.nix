{ outputs, config, lib, ... }:

rec {
  # You can import other home-manager modules here
  imports = [
    # Custom modules
    outputs.homeManagerModules

    # Modules
    ../shared/bash
  ];

  hm-modules = { bash.enable = true; };

  # Set your username
  home = {
    username = lib.mkDefault "rpi";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "24.05";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
