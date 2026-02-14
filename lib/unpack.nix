{
  pkgs,
}:

{
  unpackFile =
    { src }:
    pkgs.stdenv.mkDerivation {
      inherit src;
      name = "unpacked";
      nativeBuildInputs = [ pkgs.unzip ];
      sourceRoot = ".";
      buildPhase = ''
        runHook preBuild

        mkdir -- $out
        mv -v -- ./* $out/

        runHook postBuild
      '';

      preferLocalBuild = true;
      allowSubstitutes = false;
    };
}
