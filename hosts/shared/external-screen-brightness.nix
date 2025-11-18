{ config, pkgs, ... }:
{
  hardware.i2c = {
    enable = true;
  };

  users.users.keanu.extraGroups = [ "i2c" ];
}
