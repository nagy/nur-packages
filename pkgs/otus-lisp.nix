{ lib, stdenv, fetchFromGitHub, xxd }:

stdenv.mkDerivation rec {
  pname = "otus-lisp";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "yuriy-chumak";
    repo = "ol";
    rev = version;
    sha256 = "sha256-+6qH1BhvMkuG2rUOfo9qMjMjhCib9KONQTBWS27c3Ts=";
  };

  nativeBuildInputs = [ xxd ];

  makeFlags = [ "PREFIX=$(out)" "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    description = "A purely functional dialect of Lisp";
    inherit (src.meta) homepage;
    license = with licenses; [ mit lgpl3Only ]; # dual licensed
    platforms = platforms.unix;

  };
}
