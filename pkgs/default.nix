# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{
  pkgs ? (import ../nixpkgs.nix) { },
}:
with pkgs;
{
  sddm-sugar-dark-theme = pkgs.callPackage ./sddm-sugar-dark { };
  sddm-sugar-candy-theme = pkgs.callPackage ./sddm-sugar-candy { };
  ib-tws = pkgs.callPackage ./ib-tws { };
  # world-monitor = pkgs.callPackage ./world-monitor {
  #   inherit
  #     lib
  #     appimageTools
  #     fetchurl
  #     pkgs
  #     ;
  # };
  loa-logs = pkgs.callPackage ./loa-logs {
    inherit
      lib
      appimageTools
      pkgs
      ;
  };

}
