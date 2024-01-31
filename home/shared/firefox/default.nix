{ inputs, config, pkgs, lib, ... }:
let
  cfg = config.hm-modules.firefox;
  addons = inputs.firefox-addons.packages.${pkgs.system};
in with lib; {
  options.hm-modules.firefox = { enable = mkEnableOption "firefox"; };

  config = mkIf cfg.enable {

    programs.firefox = {
      enable = true;
      nativeMessagingHosts = [ pkgs.browserpass ];
      profiles.keanu = {
        extensions = with addons; [ ublock-origin browserpass org-capture ];
        bookmarks = { };
        settings = {
          # TODO Settings to investigate
          "browser.startup.couldRestoreSession.count" = 1;
          "browser.startup.page" = 3;
          "browser.download.useDownloadDir" = false;
          "browser.download.always_ask_before_handling_new_types" = true;
          "browser.download.panel.shown" = true;
          "browser.search.region" = "GB";
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "general.useragent.locale" = "en-GB";

          # To make org-protocol captures work with extension
          "dom.no_unknown_protocol_error.enabled" = false;
          "security.external_protocol_requies_permission" = false;

          # "browser.disableResetPrompt" = true;
          # "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          # "browser.shell.checkDefaultBrowser" = false;
          # "browser.shell.defaultBrowserCheckCount" = 1;
          # "browser.startup.homepage" = "https://start.duckduckgo.com";
          # "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"nav-bar":["back-button","forward-button","stop-reload-button","home-button","urlbar-container","downloads-button","library-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":18,"newElementCount":4}'';
          # "dom.security.https_only_mode" = true;
          # "identity.fxaccounts.enabled" = false;
          # "privacy.trackingprotection.enabled" = true;
          # "signon.rememberSignons" = false;
        };

        search = {
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];

              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
          };
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "text/xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
  };
}
