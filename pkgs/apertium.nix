{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool, libxml2, libxslt
, pkg-config, flex, pcre, pcre-cpp, icu, lttoolbox, autoreconfHook, utf8cpp }:

stdenv.mkDerivation rec {
  pname = "apertium";
  version = "3.8.2";

  src = fetchFromGitHub {
    owner = "apertium";
    repo = "apertium";
    rev = "v${version}";
    sha256 = "sha256-F8VJoh/9tQw9R+SLlty6UeiafmMmoR+W4+kofpanH/E=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    utf8cpp
    autoconf
    automake
    libtool
    libxml2
    libxslt
    flex
    pcre
    pcre-cpp
    icu
    lttoolbox
  ];

  LDFLAGS = [
    "-std=c++17"
  ];

  postPatch = ''
    for file in apertium/*.h apertium/*.cc ; do
      substituteInPlace $file \
          --replace "<utf8.h>" "<utf8cpp/utf8.h>"
    done
  '';

  meta = with lib; {
    description = "A free/open-source machine translation platform";
    homepage = "https://www.apertium.org/";

    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
