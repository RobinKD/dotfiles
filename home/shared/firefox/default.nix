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
          # General settings
          "browser.startup.couldRestoreSession.count" = 1;
          "browser.startup.page" = 3;
          "layout.spellcheckDefault" = 0;
          "browser.download.useDownloadDir" = false;
          "browser.download.always_ask_before_handling_new_types" = true;
          # Do not share geoloc ip
          "geo.enabled" = false;
          # Home settings
          "browser.newtabpage.activity-stream.feeds.topsites" = false;

          # Search settings
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "browser.urlbar.placeholderName.private" = "DuckDuckGo";

          "browser.download.panel.shown" = true;
          "browser.search.region" = "GB";
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "general.useragent.locale" = "en-GB";
          "browser.translations.panelShown" = false;

          # To make org-protocol captures work with extension
          "dom.no_unknown_protocol_error.enabled" = false;
          "security.external_protocol_requies_permission" = false;

          # Some security settings
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.donottrackheader.enabled" = true;
          "signon.rememberSignons" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "dom.forms.autocomplete.formautofill" = false;
          "toolkit.telemetry.pioneer-new-studies-available" = false;

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
            "Bing".metaData.hidden = true;
            "Amazon.co.uk".metaData.hidden = true;
            "eBay".metaData.hidden = true;
            "NixOS Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
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
              definedAliases = [ "@nop" ];
            };
            "NixOS options" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
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
              definedAliases = [ "@noo" ];
            };

            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@now" ];
            };

            "Home Manager options" = {
              urls = [{
                template =
                  "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}";
              }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              definedAliases = [ "@hmo" ];
            };
            "GitLab" = {
              urls = [{
                template = "https://gitlab.com/search?search={searchTerms}";
              }];
              iconUpdateURL =
                "https://images.ctfassets.net/xz1dnu24egyd/3JZABhkTjUT76LCIclV7sH/17a92be9bce78c2adcc43e23aabb7ca1/gitlab-logo-500.svg";
              definedAliases = [ "@gitl" ];
            };
            "GitHub" = {
              urls = [{
                template =
                  "https://github.com/search?q={searchTerms}&type=repositories";
              }];
              iconUpdateURL =
                "https://cdn-icons-png.flaticon.com/512/25/25231.png";
              definedAliases = [ "@gith" ];
            };
            "Youtube" = {
              urls = [{
                template =
                  "https://www.youtube.com/results?search_query={searchTerms}";
              }];
              iconUpdateURL =
                "https://fr.m.wikipedia.org/wiki/Fichier:YouTube_full-color_icon_%282017%29.svg";
              definedAliases = [ "@yt" ];
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
