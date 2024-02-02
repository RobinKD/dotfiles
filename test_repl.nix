/* To use, go to flake repo, then put your host and username in the defined vars
   Import has to be the file you want to test
   Run nix repl --file test_repl.nix
   The result is available in nix repl with :p test
*/
let
  host = "aquila";
  username = "keanu";
  nixos = builtins.getFlake "/home/${username}/.dotfiles/"; # or your own path
in rec {
  inherit nixos;
  inherit (nixos) inputs nixosConfigurations;
  lib = inputs.nixpkgs.lib;
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  config = nixosConfigurations.${host}.config;
  homeConfig = config.home-manager.users.${username};
  options = nixosConfigurations.${host}.options;
  /* Replace inherit config by config = homeConfig if file is called
     from home.nix
  */
  test = import ./hosts/shared/custom-services/test_run_command.nix {
    inherit lib pkgs config options;
  };
}

