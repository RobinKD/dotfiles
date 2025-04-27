{
  stdenv,
  fetchgit,
  pkgs,
}:
let
  wallpaper = ../../wallpapers/background7.jpg;
in
stdenv.mkDerivation rec {
  name = "sddm-sugar-candy-theme";
  version = "1.1";

  dontWrapQtApps = true;
  buildInputs = with pkgs.libsForQt5.qt5; [ qtgraphicaleffects ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/sugar-candy

    chmod 755 $out/share/sddm/themes/sugar-candy/Backgrounds
    cp -f ${wallpaper} $out/share/sddm/themes/sugar-candy/Backgrounds/my_background.jpg
    chmod 555 $out/share/sddm/themes/sugar-candy/Backgrounds

    runHook postInstall
  '';

  # Removed from postInstall
  # substituteInPlace $out/share/sddm/themes/sugar-candy/theme.conf --replace "ScreenWidth" "# ScreenWidth"
  # substituteInPlace $out/share/sddm/themes/sugar-candy/theme.conf --replace "ScreenHeight" "# ScreenHeight"
  postInstall = ''
    substituteInPlace $out/share/sddm/themes/sugar-candy/theme.conf --replace "Mountain.jpg" "my_background.jpg"
    substituteInPlace $out/share/sddm/themes/sugar-candy/theme.conf --replace "HeaderText" "# HeaderText"
  '';
  src = fetchgit {
    url = "https://framagit.org/MarianArlt/sddm-sugar-candy.git";
    rev = "v.${version}";
    hash = "sha256-HgUoVMaOZ4wdiP9MTvXhI5o3ItQUoXX/NtnokR42A9c=";
  };

}
