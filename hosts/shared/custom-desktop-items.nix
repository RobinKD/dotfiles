{ config, pkgs, ... }:
let
  chatGPT-icon = pkgs.fetchurl {
    url = "https://cdn3.iconfinder.com/data/icons/modern-future-technology/128/chat-gpt-512.png";
    sha256 = "sha256-qPueVhne6TAFzC9PG7xPnO4+Pj6wszPY/45UpZmrheY=";
  };

  chatgpt = pkgs.makeDesktopItem {
    name = "ChatGPT";
    desktopName = "ChatGPT";
    comment = "Open chatgpt in Tor";
    exec = "tor-browser --new-tab chatgpt.com";
    icon = chatGPT-icon;
    terminal = false;
  };
in
{
  environment.systemPackages = with pkgs; [
    chatgpt
  ];

}
