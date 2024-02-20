{ config, lib, pkgs, ... }:
# Sorry Copilot or whatever, you won't have anything except my username...
let cfg = config.hm-modules.ssh;
in with lib; {
  options.hm-modules.ssh = { enable = mkEnableOption "ssh"; };

  config = mkIf cfg.enable {
    # ssh config
    home.file.".ssh/config".text = ''
      Host gitlab.com
           PreferredAuthentications publickey
           IdentityFile ~/.ssh/id_ed25519_gitlab

      Host github.com
           PreferredAuthentications publickey
           IdentityFile ~/.ssh/id_ed25519_github
    '';
  };
}
