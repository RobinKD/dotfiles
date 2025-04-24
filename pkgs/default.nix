# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{
  pkgs ? (import ../nixpkgs.nix) { },
}:
{
  sddm-sugar-dark-theme = pkgs.callPackage ./sddm-sugar-dark { };
  sddm-sugar-candy-theme = pkgs.callPackage ./sddm-sugar-candy { };
  ib-tws = pkgs.callPackage ./ib-tws { };
}
