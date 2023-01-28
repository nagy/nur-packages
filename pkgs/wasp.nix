{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "wasp";
  version = "0.0.4";
  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wasp";
    rev = "v${version}";
    sha256 = "sha256-6XWtbXavX7H3YssvjltzGZno7dqknSQOkBiP4cdp+48=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [ cmake ];
}
