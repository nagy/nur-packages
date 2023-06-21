{ lib, pkgsi686Linux, fetchFromGitHub, sbcl }:

pkgsi686Linux.stdenv.mkDerivation rec {

  pname = "lbforth";
  version = "unstable-2023-02-13";

  src = fetchFromGitHub {
    owner = "larsbrinkhoff";
    repo = pname;
    rev = "912433b150b64252070116a5fd5c1a29ff29b26d";
    sha256 = "sha256-Nh6IuSoaggI98+FWAE4he+RhOoRZ4zczqlZGP7j68jw=";
    fetchSubmodules = true;
  };
  dontConfigure = true;

  nativeBuildInputs = [ sbcl ];

  preBuild = "./configure";

  preInstall = "mkdir -p $out/bin";

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Self-hosting metacompiled Forth, bootstrapping from a few lines of C; targets Linux, Windows, ARM, RISC-V, 68000, PDP-11, asm.js";
    license = licenses.gpl3Plus;
    mainProgram = "forth";
  };
}
