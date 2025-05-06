{
  config,
  pkgs,
  inputs,
  ...
}:
let
  org-capture-desktop = pkgs.makeDesktopItem {
    name = "org-protocol";
    desktopName = "Org-Protocol Capture";
    icon = "emacs";
    exec = "emacsclient -- %u";
    type = "Application";
    terminal = false;
    startupWMClass = "Emacs";
    categories = [ "System" ];
    mimeTypes = [ "x-scheme-handler/org-protocol" ];
  };
  myEmacs = # Emacs config
    # All packages are pulled from straight
    (
      (pkgs.extend inputs.emacs-overlay.overlay).emacsWithPackagesFromUsePackage {
        # Your Emacs config file. Org mode babel files are also
        # supported.
        # NB: Config files cannot contain unicode characters, since
        #     they're being parsed in nix, which lacks unicode
        #     support.
        config = ../../emacs_config.org;

        # Whether to include your config as a default init file.
        # If being bool, the value of config is used.
        # Its value can also be a derivation like this if you want to do some
        # substitution:
        #   defaultInitFile = pkgs.substituteAll {
        #     name = "default.el";
        #     src = ./emacs.el;
        #     inherit (config.xdg) configHome dataHome;
        #   };
        # defaultInitFile = true;

        # Package is optional, defaults to pkgs.emacs
        package = pkgs.emacs-pgtk;

        # By default emacsWithPackagesFromUsePackage will only pull in
        # packages with `:ensure`, `:ensure t` or `:ensure <package name>`.
        # Setting `alwaysEnsure` to `true` emulates `use-package-always-ensure`
        # and pulls in all use-package references not explicitly disabled via
        # `:ensure nil` or `:disabled`.
        # Note that this is NOT recommended unless you've actually set
        # `use-package-always-ensure` to `t` in your config.
        alwaysEnsure = true;

        # For Org mode babel files, by default only code blocks with
        # `:tangle yes` are considered. Setting `alwaysTangle` to `true`
        # will include all code blocks missing the `:tangle` argument,
        # defaulting it to `yes`.
        # Note that this is NOT recommended unless you have something like
        # `#+PROPERTY: header-args:emacs-lisp :tangle yes` in your config,
        # which defaults `:tangle` to `yes`.
        alwaysTangle = true;

        # Optionally provide extra packages not in the configuration file.
        # This can also include extra executables to be run by Emacs (linters,
        # language servers, formatters, etc)
        extraEmacsPackages =
          epkgs: with pkgs; [
            epkgs.vterm
            epkgs.mu4e
            epkgs.catppuccin-theme
            # Treesit highlighting
            epkgs.treesit-grammars.with-all-grammars

            shellcheck
            enchant
            pandoc
            nixfmt-rfc-style # Format nix files
            nil # Nix LSP
            shfmt
            shellcheck
            nodePackages.bash-language-server # Bash LSP
          ];

        # Optionally override derivations.
        # override = final: prev: {
        #   weechat = prev.melpaPackages.weechat.overrideAttrs(old: {
        #     patches = [ ./weechat-el.patch ];
        #   });
        # };
      }
    );
in
{
  home.packages = with pkgs; [
    org-capture-desktop
    isync
    sqlite
    (aspellWithDicts (
      ps: with ps; [
        en
        fr
      ]
    ))
    myEmacs
  ];

  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = true;
    package = myEmacs;
    # socketActivation.enable = true; # Might be useful, who knows?
  };
}
