{ config, lib, ... }:
let
  cfg = config.hm-modules.bash;
  homeDir = config.home.homeDirectory;
  dotDir = "${homeDir}/.dotfiles";
  nixos-buildopts = "--option cores 3 --option max-jobs 6";
in
with lib;
{
  options.hm-modules.bash = {
    enable = mkEnableOption "bash";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true; # Already default
      historySize = 10000;
      historyIgnore = [
        "ls"
        "cd"
        "exit"
      ];
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
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };
      shellAliases = {
        # some more ls aliases
        ll = "eza --icons  -a --group-directories-first -1 --no-user --long";
        l = "eza --icons  -a --group-directories-first -1";
        tree = "eza --icons --tree --group-directories-first";

        # Alias for doom emacs;
        doom = "${homeDir}/.config/emacs/bin/doom";
        restart-emacs = "systemctl restart --user emacs";
        doom-emacs = "emacs --init-directory=.config/emacs/";
        emacs-debug = "emacs --debug-init";

        # Alias nixos;
        nrb = "nfu; sudo nixos-rebuild boot --flake ${dotDir} ${nixos-buildopts}";
        nrbwc = "nfu; sudo nixos-rebuild boot -p WorkingConfig --flake ${dotDir} ${nixos-buildopts}";
        nrt = "nfu; sudo nixos-rebuild test --flake ${dotDir} ${nixos-buildopts}";
        nrs = "nfu; sudo nixos-rebuild switch --flake ${dotDir} ${nixos-buildopts}";
        nrtnu = "sudo nixos-rebuild test --flake ${dotDir} ${nixos-buildopts}";
        nrsnu = "sudo nixos-rebuild switch --flake ${dotDir} ${nixos-buildopts}";
        nrdb = "nfu; sudo nixos-rebuild dry-build --flake ${dotDir} ${nixos-buildopts}";
        nfu = "sudo nix flake update --flake ${dotDir} ${nixos-buildopts}";
        ncg = "nix-collect-garbage";
        fh-init = ''nix run "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz" -- init'';

        # Run external programs -> alien app -- args
        alien = "nix-alien-ld";
        signal = "signal-desktop --use-tray-icon --no-sandbox %U";

        # Win 10 VM with QEMU
        win10 = "quickemu --vm vms/windows-10.conf";
        view_vm = "remote-viewer spice://127.0.0.1:5900 & disown";
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
          nix store diff-closures /run/current-system ${dotDir}/build_updates
        }

        show_booted_updates() {
          nix store diff-closures /run/booted-system /run/current-system
        }

        update_passwords() {
          if [ $(stat --format "%Z" ${homeDir}/.password-store) -gt $(stat --format "%Z" ${dotDir}/secrets/pass_bkp.tar.gz) ]; then
            echo "Archive is older, nothing to do..."
          else
            echo "Archive is newer, update and delete removed files!"
            sops --config ${dotDir}/.sops.yaml -d ${dotDir}/secrets/pass_bkp.tar.gz > ${dotDir}/pass.tar.gz
            mkdir ${dotDir}/passwords
            tar -xf ${dotDir}/pass.tar.gz -C ${dotDir}/passwords
            echo -e "Preview synchronisation:\n"
            rsync -aP ${dotDir}/passwords${homeDir}/.password-store/ ${homeDir}/.password-store/ --delete --dry-run
            echo -e "\n\n"
            read -p "Update? (y/N) " confirm
            if [ $confirm == "y" ]; then
               echo -e "\nPerforming update...\n"
               rsync -aP ${dotDir}/passwords${homeDir}/.password-store/ ${homeDir}/.password-store/ --delete
            fi
            rm -rf ${dotDir}/passwords
            rm ${dotDir}/pass.tar.gz
          fi
        }
      '';
    };
  };
}
