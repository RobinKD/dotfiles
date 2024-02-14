{ config, lib, pkgs, nixosConfig, ... }:
let
  cfg = config.hm-modules.dev-languages;
  nvidiaPrimeCfg = nixosConfig.hardware.nvidia.prime;
  nvidia-enabled = if (nvidiaPrimeCfg.sync.enable
    || nvidiaPrimeCfg.offload.enable || nvidiaPrimeCfg.reverseSync.enable) then
    true
  else
    false;
in with lib; {
  options.hm-modules.dev-languages = {
    python.enable = mkEnableOption "python";
    latex.enable = mkEnableOption "latex";
    web.enable = mkEnableOption "web";
  };

  config = (mkMerge [
    (mkIf cfg.python.enable {
      home.packages = with pkgs;
        [
          (python3.withPackages (ps:
            with ps; [
              numpy
              pandas
              matplotlib
              python-lsp-server
              python-lsp-ruff
              rope
              pylsp-rope
            ]))

          python3Packages.pytest
          ruff
        ] ++ [
          # YAML LSP server
          yaml-language-server
          # Yaml formatting
          nodePackages.prettier
        ];
    })
    # (mkIf (cfg.python.enable && nvidia-enabled) {
    #   home.packages = with pkgs; [ cudaPackages.cudatoolkit ];
    # })
    (mkIf cfg.latex.enable {
      home.packages = with pkgs;
        [
          (texlive.combine {
            inherit (texlive)
              biblatex scheme-medium sttools datetime2 datetime ninecolors
              multirow fmtcount pgfplots adjustbox appendixnumberbeamer
              tabularray wrapfig capt-of doublestroke animate media9 zref ocgx2;
            #  animate media9 zref ocgx2 are for animated tikz
          })
        ] ++ [
          # Latex LSP
          texlab
        ];
    })
    (mkIf cfg.web.enable { home.packages = with pkgs; [ nodejs ]; })
  ]);
}
