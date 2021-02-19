{ pkgs }:
let
  preloaded = pkgs.stdenv.mkDerivation {
    name = "preloaded";
    src = ./main.c;
    dontUnpack = true;
    buildPhase = ''
     cc -shared $src
    '';
    installPhase = ''
     install -Dm755 a.out $out
    '';
  };
in
pkgs.runCommand "aqbanking" {
  buildInputs = [ pkgs.makeWrapper ];
}
  ''
    mkdir $out
    # Link every top-level folder from pkgs.aqbanking to our new target
    ln -s ${pkgs.aqbanking}/* $out
    # Except the bin folder
    rm $out/bin
    mkdir $out/bin
    # We create the bin folder ourselves and link every binary in it
    ln -s ${pkgs.aqbanking}/bin/* $out/bin
    # Except the aqbanking-cli binary
    rm $out/bin/aqbanking-cli
    # Because we create this ourself, by creating a wrapper
    makeWrapper ${pkgs.aqbanking}/bin/aqbanking-cli $out/bin/aqbanking-cli \
      --prefix LD_PRELOAD : ${preloaded}
  ''
