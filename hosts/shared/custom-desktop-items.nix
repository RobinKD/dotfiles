{ config, pkgs, ... }:
let
  chatGPT-icon = pkgs.fetchurl {
    url = "https://logovent.com/blog/wp-content/uploads/2024/09/Chat-GPT-icon-2022-%E2%80%93-Today.png";
    sha256 = "sha256-ECzbVDVN415+sW6B16mqTqjoUe9e+CFx9e0SPefIdFY=";
  };

  chatgpt = pkgs.makeDesktopItem {
    name = "ChatGPT";
    desktopName = "ChatGPT";
    comment = "Open chatgpt in Tor";
    exec = "librewolf  --new-tab chatgpt.com";
    icon = chatGPT-icon;
    terminal = false;
  };

  grok-icon = pkgs.fetchurl {
    url = "https://1000logos.net/wp-content/uploads/2025/02/Grok-Logo.png";
    sha256 = "sha256-tk0mopw2IHyJPGk7Yx5/wQgoslrvf+UFMUkQG9OGcy4=";
  };

  grok = pkgs.makeDesktopItem {
    name = "Grok";
    desktopName = "Grok";
    comment = "Open Grok in Librewolf";
    exec = "librewolf --new-tab grok.com";
    icon = grok-icon;
    terminal = false;
  };

  gemini-icon = pkgs.fetchurl {
    url = "https://www.google.com/s2/favicons?domain=gemini.google.com";
    sha256 = "sha256-VB/3AbMdDpxRE7JjFTHGPBXHLuYcNDVsOv118bkQCzw=";
  };

  gemini = pkgs.makeDesktopItem {
    name = "Gemini";
    desktopName = "Gemini";
    comment = "Open Gemini in Librewolf";
    exec = "librewolf --new-tab gemini.google.com";
    icon = gemini-icon;
    terminal = false;
  };
in
{
  environment.systemPackages = with pkgs; [
    chatgpt
    grok
    gemini
  ];

}
