{
  lib,
  stdenv,
  pkgs,
  appimageTools,
}:

let
  pname = "loa-logs";
  version = "1.44.0-nineveh.beta.23";
  version_ninev = "1.44.0-nineveh.beta.21";

  logs = pkgs.fetchurl {
    url = "https://github.com/snoww/loa-logs/releases/download/v${version}/LOA.Logs_${version}_amd64.AppImage";
    sha256 = "sha256-nnhbEMdxlLbz3mwrukgwpRtyAf7UiP0qmUP1o9JbKgk=";
  };

  nineveh = pkgs.fetchurl {
    url = "https://github.com/snoww/loa-logs/releases/download/v${version_ninev}/nineveh";
    sha256 = "sha256-qt4DsvhfOHzo/sTWpkXHSYFVuNGl0UmZFz45O1O80Xk=";
  };
in
appimageTools.wrapType2 rec {
  inherit pname version;

  src = logs;

  nativeBuildInputs = [
    pkgs.makeWrapper
  ];

  extraInstallCommands = ''
    mkdir -p $out/bin
    cp ${nineveh} $out/bin/nineveh
    chmod +x $out/bin/nineveh

    wrapProgram $out/bin/${pname} --unset QT_PLUGIN_PATH
  '';

  meta = with lib; {
    description = "LoA logs AppImage packaged for NixOS";
    homepage = "https://github.com/snoww/loa-logs";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
