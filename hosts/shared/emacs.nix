{ pkgs }:

let
  # The let expression below defines a myEmacs binding pointing to the
  # current stable version of Emacs. This binding is here to separate
  # the choice of the Emacs binary from the specification of the
  # required packages.
  myEmacs = pkgs.emacs;
  # This generates an emacsWithPackages function. It takes a single
  # argument: a function from a package set to a list of packages
  # (the packages that will be available in Emacs).
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
  # The rest of the file specifies the list of packages to install.
  org-capture-desktop = pkgs.makeDesktopItem {
    name = "org-protocol";
    desktopName = "Org-Protocol Capture";
    icon = "emacs";
    exec = "emacsclient %u";
    type = "Application";
    terminal = false;
    categories = [ "System" ];
    mimeTypes = [ "x-scheme-handler/org-protocol" ];
  };
in
{
  system_packages = with pkgs; [
    # Emacs
    org-capture-desktop
    (ollama.override { acceleration = "cuda"; }) # Doesn't seem to compile for now
    emacsPackages.mu4e
    isync
    sqlite
    (aspellWithDicts (
      ps: with ps; [
        en
        fr
      ]
    ))
    enchant
    pandoc
    nixfmt-rfc-style # Format nix files
    nil # Nix LSP
    shfmt
    shellcheck
    nodePackages.bash-language-server # Bash LSP
  ];

  packaged-emacs = emacsWithPackages (
    epkgs:
    with epkgs;
    [
      vterm
      # Treesit highlighting
      treesit-grammars.with-all-grammars
    ]
    ++ (with epkgs.melpaStablePackages; [
      rg # Ripgrep with emacs
      yasnippet # My lazy bones are happy
    ])
    # Two packages (undo-tree and zoom-frm) are taken from MELPA.
    ++ (with epkgs.melpaPackages; [
      meow # My personal keybinds
      magit # ; Integrate git <C-x g>

      which-key

      # Theming
      catppuccin-theme # My soothing theme
      hl-todo
      highlight-indent-guides
      doom-modeline
      git-gutter
      nerd-icons-corfu

      # Competion UI
      vertico
      consult
      orderless
      marginalia
      nerd-icons-completion
      corfu
      cape
      embark
      embark-consult
      consult-yasnippet
      yasnippet-capf
      yasnippet-snippets

      # Projects
      project-tab-groups

      # Org stuff
      org-modern
      org-mime
      org-auto-tangle
      org-download
      org-super-agenda
      doct # Easier org captures
      org-roam # Of course!
      org-ref
      citar
      embark
      citar-embark
      citar-org-roam
      org-roam-bibtex
      org-noter
      org-roam-ui
      # For org roam UI
      simple-httpd
      f

      #Language
      # Formatting
      treesit-auto # Might be useless later
      # format-all
      apheleia # Seems better than format-all
      # Spelling
      jinx
      # LaTeX
      auctex

      # Modes
      python-pytest

      yaml-mode
      yaml-pro

      nix-mode
      nix-ts-mode

      # Varied
      fzf
      pdf-tools
      mu4e-alert
      org-msg
      envrc
      emacs-everywhere
      gptel # Discuss with ai, blame me :/
      # undo-tree      # ; <C-x u> to show the undo tree
      # zoom-frm       # ; increase/decrease font size for all buffers %lt;C-x C-+>
    ])
    # # Three packages are taken from GNU ELPA.
    # ++ (with epkgs.elpaPackages; [
    #   auctex         # ; LaTeX mode
    #   beacon         # ; highlight my cursor when scrolling
    #   nameless       # ; hide current package name everywhere in elisp code
    # ])
    # # notmuch is taken from a nixpkgs derivation which contains an Emacs mode.
    # ++ [
    #   pkgs.notmuch   # From main packages set
    # ]
  );
}
