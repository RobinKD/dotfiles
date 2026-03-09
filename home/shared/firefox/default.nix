{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfgff = config.hm-modules.firefox;
  cfglw = config.hm-modules.librewolf;
  extensions = {
    "uBlock0@raymondhill.net" = {
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      private_browsing = true;
    };
    "browserpass@maximbaz.com" = {
      installation_mode = "force_installed";
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/browserpass-ce/latest.xpi";
    };
  };
  added-engines = [
    {
      Name = "Qwant";
      URLTemplate = "https://www.qwant.com/?q={searchTerms}&locale=en_GB";
      Method = "GET";
      IconURL = "https://www.qwant.com/public/favicon.066f5ee2ab77b590bb5846c32c57cb84.ico";
      Alias = "@qwant";
      Description = "Search with Qwant";
    }
    {
      Name = "Nixpkgs (unstable)";
      URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
      Method = "GET";
      IconURL = "https://nixos.org/favicon.ico";
      Alias = "@nixpkg";
      Description = "Search in nixpkgs (unstable)";
    }
    {
      Name = "Nixpkgs (unstable) options";
      URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
      Method = "GET";
      IconURL = "https://nixos.org/favicon.ico";
      Alias = "@nixopt";
      Description = "Search in nixpkgs (unstable) options";
    }
    {
      Name = "NixOS Wiki";
      URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
      Method = "GET";
      IconURL = "https://nixos.org/favicon.ico";
      Alias = "@nixw";
      Description = "Search in nixOS Wiki";
    }
    {
      Name = "Home manager options";
      URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}";
      Method = "GET";
      IconURL = "https://nixos.org/favicon.ico";
      Alias = "@hmo";
      Description = "Home manager options";
    }
    {
      Name = "Google Scholar";
      URLTemplate = "https://scholar.google.com/scholar?q={searchTerms}";
      Method = "GET";
      IconURL = "https://scholar.google.com/favicon.ico";
      Alias = "@scholar";
      Description = "Search in Google Scholar";
    }
    {
      Name = "Youtube";
      URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
      Method = "GET";
      IconURL = "https://www.youtube.com/favicon.ico";
      Alias = "@yt";
      Description = "Search in Youtube";
    }
  ];
  common-params = {
    PromptForDownloadLocation = true;
    DontCheckDefaultBrowser = true;
    DisableFormHistory = true;
    DisableProfileImport = true;
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    EnableTrackingProtection = {
      Value = true;
      Cryptomining = true;
      Fingerprinting = true;
      EmailTracking = true;
      SuspectedFingerprinting = true;
    };
    FirefoxHome = {
      TopSites = false;
      SponsoredTopSites = false;
    };
    RequestedLocales = [ "en-GB" ];
    Homepage = {
      StartPage = "previous-session";
    };
    GenerativeAI = {
      Enabled = false; # Disables everything by default
      Locked = true;
    };
    AutofillAddressEnabled = false;
    AutofilleCreditCardEnabled = false;
    PasswordManagerEnabled = false;
    Preferences = {
      "geo.enabled" = false;
    };
  };
in
with lib;
{
  options.hm-modules.firefox = {
    enable = mkEnableOption "firefox";
  };

  options.hm-modules.librewolf = {
    enable = mkEnableOption "librewolf";
  };

  config = mkMerge [
    (mkIf cfgff.enable {
      programs.firefox = {
        enable = true;
        languagePacks = [ "en-GB" ];
        nativeMessagingHosts = [ pkgs.browserpass ];
        policies = {
          ExtensionSettings = extensions // {
            "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
            };
          };
          SanitizeOnShutdown = {
            Cache = true;
            Cookies = false;
            FormData = true;
            History = false;
            Sessions = false;
            SiteSettings = false;
            Locked = false;
          };
          SearchEngines = {
            Remove = [
              "Bing"
              "DuckDuckGo"
              "eBay"
            ];
            Add = added-engines;
            Default = "Qwant";
          };
        }
        // common-params;
      };

      xdg.mimeApps.defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "text/xml" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
      };
    })
    (mkIf cfglw.enable {
      programs.librewolf = {
        enable = true;
        languagePacks = [ "en-GB" ];
        nativeMessagingHosts = [ pkgs.browserpass ];
        policies = {
          ExtensionSettings = extensions;
          SanitizeOnShutdown = true;
          SearchEngines = {
            Remove = [
              "DuckDuckGo"
              "eBay"
            ];
            Add = added-engines;
            Default = "Qwant";
          };
        }
        // common-params;
      };
    })
  ];
}
