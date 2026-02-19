{
  pkgs,
  lib ? pkgs.lib,
}:

let
  emacs = pkgs.emacs-nox.pkgs.withPackages (epkgs: [ epkgs.org-ref ]);

  conversions = {
    org.json =
      { src }:
      {
        inherit src;
        nativeBuildInputs = [
          emacs
          pkgs.jq
        ];
        __cmd = ''
          emacs --batch $src \
            --eval '(princ (json-encode (org-export-get-environment)))' \
            | jq --sort-keys > $out
        '';
      };
    org.tex =
      { src }:
      {
        inherit src;
        nativeBuildInputs = [ emacs ];
        __cmd = ''
          ORGCMD=latex;
          if [[ "$src" == *presentation.org ]] ; then
            ORGCMD=beamer
          fi
          emacs --batch \
            -l org-ref \
            --eval "(setq enable-local-variables :all)" \
            $src \
            --eval '(setq default-directory (getenv "PWD"))' \
            -f org-$ORGCMD-export-to-latex
          install -Dm644 *.tex $out
        '';
      };
    tex.pdf =
      { src }:
      {
        inherit src;
        nativeBuildInputs = [
          (pkgs.texlive.combine {
            inherit (pkgs.texlive)
              scheme-small
              llncs
              wrapfig
              ulem
              capt-of
              biblatex
              latexmk
              beamer
              pgfgantt
              svg
              trimspaces
              transparent
              catchfile
              koma-script
              xpatch
              etoolbox
              mathtools
              kpfonts
              totalcount
              lstaddons
              enumitem
              chngcntr
              subfigure
              floatrow
              csquotes
              algorithm2e
              ifoddpage
              relsize
              tcolorbox
              environ
              tikzfill
              pdfcol
              cleveref
              mathpazo
              lualatex-math
              ;
          })
          pkgs.biber
          pkgs.writableTmpDirAsHomeHook
        ];
        __cmd = ''
          export TMPDIR=/tmp
          latexmk -pdf -halt-on-error --shell-escape $src
          install -Dm644 *.pdf $out
        '';
      };
  };
in
rec {
  convert =
    { src, output }:
    let
      fileExtension = lib.last (lib.splitString "." (src.name or (toString src)));
      fileBase = lib.removeSuffix ".${fileExtension}" (lib.baseNameOf (src.name or (toString src)));
      entry =
        (conversions.${fileExtension}.${output}
          or (throw "No conversion from ${fileExtension} to ${output} found.")
        )
          {
            inherit src;
          };
    in
    if lib.isDerivation entry then
      entry
    else
      pkgs.runCommandLocal "${fileBase}.${output}" entry ''
        ${entry.__cmd}
      '';

}
