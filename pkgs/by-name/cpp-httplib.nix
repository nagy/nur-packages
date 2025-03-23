{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cpp-httplib";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v${version}";
    hash = "sha256-FRyc3CmJ8vnv2eSTOpypLXN6XpdzMbD6SEdzpZ2ns3A=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A C++ header-only HTTP/HTTPS server and client library";
    homepage = "https://github.com/yhirose/cpp-httplib";

    license = licenses.mit;
    platforms = platforms.all;
  };
}
