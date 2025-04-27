{
  stdenv,
  fetchFromGitHub,
  pkgs,
}:
let
  wallpaper = ../../wallpapers/background7.jpg;
in
stdenv.mkDerivation rec {
  name = "sddm-sugar-dark-theme";
  version = "1.2";

  dontWrapQtApps = true;
  buildInputs = with pkgs.libsForQt5.qt5; [ qtgraphicaleffects ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/sugar-dark

    chmod 755 $out/share/sddm/themes/sugar-dark/Background.jpg
    cp -f ${wallpaper} $out/share/sddm/themes/sugar-dark/Background.jpg
    chmod 555 $out/share/sddm/themes/sugar-dark/Background.jpg

    runHook postInstall
  '';
  postInstall = ''
    substituteInPlace $out/share/sddm/themes/sugar-dark/theme.conf --replace "ScreenWidth" "# ScreenWidth"
    substituteInPlace $out/share/sddm/themes/sugar-dark/theme.conf --replace "ScreenHeight" "# ScreenHeight"
  '';
  src = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "v${version}";
    sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
  };
}
