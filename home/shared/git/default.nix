{ config, lib, ... }:
# Sorry Copilot or whatever, you won't have anything except my username...
let
  cfg = config.hm-modules.git;
  secrets = (import ./secrets.nix).secrets;
  replacement =
    (import ./replacements.nix.expunged { inherit lib; }).replacement;
  replace-secrets = (secrets: replacements:
    "sed -e " + (builtins.concatStringsSep " -e "
      (lib.lists.zipListsWith (s: r: ''"s/'' + s + "/" + r + ''/g"'') secrets
        replacements)));
in with lib; {
  options.hm-modules.git = { enable = mkEnableOption "git"; };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "RobinKD";
      userEmail = "example@email.com";
      extraConfig = {
        init = { defaultBranch = "main"; };
        "filter.secrets" = {
          clean = replace-secrets secrets replacement;
          smudge = replace-secrets replacement secrets;
        };
        submodule = { recurse = true; };
      };
      aliases = {
        # TODO
      };
      signing = {
        key = "1891BFB363E4E118";
        signByDefault = true;
      };
    };
  };
}
