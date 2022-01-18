{ stdenv, lib, kaldi, openblas, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libvosk";
  version = "0.3.32";

  src = (toString (fetchFromGitHub {
    # owner = "alphacep";

    # use my fork which has some NixOS fixes.
    owner = "nagy";
    repo = "vosk-api";
    rev = "6e2e590e43e5d8495e5edcfa0523850111c487fe";
    hash = "sha256-D5uxjqZxJTNMj0oquhHfsacQDArSBoBHxuJeN2xfPIk=";
  }))+"/src/";

  KALDI_ROOT = kaldi.outPath;

  OPENBLAS_ROOT = openblas.outPath;

  HAVE_OPENBLAS_CLAPACK = "0";

  meta = with lib; {
    description = "Offline speech recognition API for Android, iOS, Raspberry Pi and servers with Python, Java, C# and Node";
    homepage = "https://github.com/alphacep/vosk-api";
    license = with licenses; [ asl20 ];
  };
}
