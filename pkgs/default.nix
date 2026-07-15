# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{
  pkgs ? (import ../nixpkgs.nix) { },
}:
with pkgs;
{
  sddm-sugar-dark-theme = pkgs.callPackage ./sddm-sugar-dark { };
  sddm-sugar-candy-theme = pkgs.callPackage ./sddm-sugar-candy { };
  opjfx = pkgs.openjfx25.override { withWebKit = true; };
  ib-tws = pkgs.callPackage ./ib-tws { openjfx-webkit = opjfx; };
  # world-monitor = pkgs.callPackage ./world-monitor {
  #   inherit
  #     lib
  #     appimageTools
  #     fetchurl
  #     pkgs
  #     ;
  # };
}
