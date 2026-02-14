{
  pkgs,
  lib ? pkgs.lib,
}:

{
  mkPdfEncrypted =
    {
      file,
      password,
    }:
    pkgs.runCommandLocal "output.pdf"
      {
        src = lib.cleanSource file;
        nativeBuildInputs = [ pkgs.pdftk ];
        env = {
          inherit file password;
        };
      }
      ''
        pdftk "$src" output output.pdf user_pw PROMPT <<< "$password"
        install -Dm644 -t "$out" output.pdf
      '';
}
