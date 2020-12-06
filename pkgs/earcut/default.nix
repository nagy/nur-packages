{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "earcut";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "earcut.hpp";
    rev = "v${version}";
    sha256 = "1lfvh7shr82g10z3ydw7rll80nyi8nba41ykkgrghh95gvr6m3k7";
  };

  phases = [ "installPhase" ];

  installPhase = ''
     install -Dm644 $src/include/mapbox/earcut.hpp $out/include/mapbox/earcut.hpp
  '';

  meta = with lib; {
    description = "Fast, header-only polygon triangulation";
    homepage = "https://github.com/mapbox/earcut";

    license = licenses.isc;
    maintainers = [  ];
    platforms = platforms.all;
  };
}
