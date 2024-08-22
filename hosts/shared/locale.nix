{ lib, ... }:

with lib;
{
  i18n = {
    defaultLocale = mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = mkDefault "en_US.UTF-8";
    };
    supportedLocales = mkDefault [
      "en_US.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
    ];
  };
  # Set your time zone.
  time.timeZone = "Europe/Paris";

  console.useXkbConfig = true; # use xkbOptions in tty.
  services.xserver.xkb.layout = "fr";
}
