{ config, pkgs, ... }:
let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.keanu = {
    isNormalUser = true;
    initialPassword = "nixos";
    home = "/home/keanu";
    extraGroups = [ "wheel" ]
      ++ ifTheyExist [ "network" "git" "networkmanager" "audio" "video" ];
  };
}
