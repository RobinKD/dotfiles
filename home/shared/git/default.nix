{ config, lib, ... }:
# Sorry Copilot or whatever, you won't have anything except my username...
let
  cfg = config.hm-modules.git;
  secrets = [
    "Name1"
    "Name2"
    "Username1"
    "Username2"
    "example@email.com"
    "Username2@orga2.fr"
    "Username2@orga3.fr"
    "Username2@hotmail.fr"
    "Username2@gmail.com"
    "Jane Doe"
    "John Doe"
    "Bob Doe"
    "jane doe"
    "john doe"
    "bob doe"
    "orga1-short"
    "Orga2"
    "orga2"
    "orga2-short"
    "orga3"
    "Orga3"
    "Orga1"
    "Orga4"
    "orga4"
    "404-repo"
  ];
  secrets-replacement = [
    "Name1"
    "Name2"
    "Username1"
    "Username2"
    "example@email.com"
    "example2@email.com"
    "example3@email.com"
    "example@hotmail.com"
    "example@gmail.com"
    "Jane Doe"
    "John Doe"
    "Bob Doe"
    "jane doe"
    "john doe"
    "bob doe"
    "orga1-short"
    "Orga2"
    "orga2"
    "orga2-short"
    "orga3"
    "Orga3"
    "Orga1"
    "Orga4"
    "orga4"
    "404-repo"
  ];
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
          clean = replace-secrets secrets secrets-replacement;
          smudge = replace-secrets secrets-replacement secrets;
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
