{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cpp-httplib";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v${version}";
    sha256 = "0c0gyfbvm34bgrqy9fhfxw1f8nb9zhf063j7xq91k892flb7qm1c";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A C++ header-only HTTP/HTTPS server and client library";
    homepage = "https://github.com/yhirose/cpp-httplib";

    license = licenses.mit;
    maintainers = [  ];
    platforms = platforms.all;
  };
}
