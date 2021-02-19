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
pkgs.runCommand "gnucash" {
  buildInputs = [ pkgs.makeWrapper ];
}
  ''
    mkdir $out
    # Link every top-level folder from pkgs.gnucash to our new target
    ln -s ${pkgs.gnucash}/* $out
    # Except the bin folder
    rm $out/bin
    mkdir $out/bin
    # We create the bin folder ourselves and link every binary in it
    ln -s ${pkgs.gnucash}/bin/* $out/bin
    # Except the gnucash binary
    rm $out/bin/gnucash
    # Because we create this ourself, by creating a wrapper
    makeWrapper ${pkgs.gnucash}/bin/gnucash $out/bin/gnucash \
      --prefix LD_PRELOAD : ${preloaded}
  ''
