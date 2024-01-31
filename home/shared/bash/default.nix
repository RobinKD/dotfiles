{ config, lib, nixosConfig, ... }:
let
  cfg = config.hm-modules.bash;
  homeDir = config.home.homeDirectory;
in with lib; {
  options.hm-modules.bash = { enable = mkEnableOption "bash"; };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true; # Already default
      historySize = 10000;
      historyIgnore = [ "ls" "cd" "exit" ];
      shellOptions = [
        # Append to history file rather than replacing it.
        "histappend"

        # check the window size after each command and, if
        # necessary, update the values of LINES and COLUMNS.
        "checkwinsize"

        # Extended globbing.
        "extglob"
        "globstar"

        # Warn if closing shell with running jobs.
        "checkjobs"
      ];
      sessionVariables = {
        EDITOR = "emacsclient";
        CUPS_GSSSERVICENAME = "ipp";
      };
      shellAliases = {
        # some more ls aliases
        ll = "ls -alF";
        la = "ls -A";
        l = "ls -CF";

        # Alias for doom emacs;
        doom = "${homeDir}/.config/emacs/bin/doom";
        restart-emacs = "systemctl restart --user emacs";
        doom-emacs = "emacs --init-directory=.config/emacs/";
        emacs-debug = "emacs --debug-init";

        # Alias nixos;
        nrb = "nfu; sudo nixos-rebuild boot --flake ${homeDir}/.dotfiles";
        nrbwc =
          "nfu; sudo nixos-rebuild boot -p WorkingConfig --flake ${homeDir}/.dotfiles";
        nrt = "nfu; sudo nixos-rebuild test --flake ${homeDir}/.dotfiles";
        nrs = "nfu; sudo nixos-rebuild switch --flake ${homeDir}/.dotfiles";
        nrdb = "nfu; sudo nixos-rebuild dry-build --flake ${homeDir}/.dotfiles";
        nfu = "sudo nix flake update ${homeDir}/.dotfiles";
        ncg = "nix-collect-garbage";

        pass-open = "sudo swapoff -a; pass open; sudo swapon";
      };
      bashrcExtra = ''
        flakify() {
          if [ ! -e flake.nix ]; then
            nix flake new -t github:nix-community/nix-direnv .
          elif [ ! -e .envrc ]; then
            echo "use flake" > .envrc
            direnv allow
          fi
        }

        show_updates() {
          echo "Updated packages:"
          nix store diff-closures /run/current-system ${homeDir}/.dotfiles/build_updates
        }

        show_booted_updates() {
          nix store diff-closures /run/booted-system /run/current-system
        }

        update_passwords() {
          sops --config ${homeDir}/.dotfiles/.sops.yaml -d ${homeDir}/.dotfiles/secrets/pass.tar.gz > ${homeDir}/.dotfiles/pass.tar.gz
          mkdir ${homeDir}/.dotfiles/passwords
          tar -xf ${homeDir}/.dotfiles/pass.tar.gz -C ${homeDir}/.dotfiles/passwords
          rsync -aP ${homeDir}/.dotfiles/passwords${homeDir}/.password-store/ ${homeDir}/.password-store/
          rm ${homeDir}/.dotfiles/pass.tar.gz
          rm -rf ${homeDir}/.dotfiles/passwords
        }

      '';
    };
  };
}
