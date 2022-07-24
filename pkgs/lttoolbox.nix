{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool, libxml2, libxslt
, pkg-config, flex, pcre, pcre-cpp, autoreconfHook, icu, utf8cpp }:
stdenv.mkDerivation rec {
  pname = "lttoolbox";
  version = "3.6.6";

  src = fetchFromGitHub {
    owner = "apertium";
    repo = "lttoolbox";
    rev = "v${version}";
    sha256 = "sha256-dEmlJ83JfMAyMeRcTh/Ca6+OLeqKxuHBhp1G5SCeJWE=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    icu
    utf8cpp
    autoconf
    automake
    libtool
    libxml2
    libxslt
    flex
    pcre
    pcre-cpp
  ];

  postPatch = ''
    for file in lttoolbox/*.h lttoolbox/*.cc ; do
      substituteInPlace $file \
          --replace "<utf8.h>" "<utf8cpp/utf8.h>"
    done
  '';

  meta = with lib; {
    description =
      "Finite state compiler, processor and helper tools used by apertium";
    homepage = "https://github.com/apertium/lttoolbox";

    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
