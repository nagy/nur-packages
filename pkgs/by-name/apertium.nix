{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  libxml2,
  libxslt,
  pkg-config,
  flex,
  pcre,
  pcre-cpp,
  icu,
  lttoolbox,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apertium";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "apertium";
    repo = "apertium";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jns4OI+HjeyTPDPsBB/bONT1vHLzqjBAoHWEB1tymwk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
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

  meta = {
    description = "Free/open-source machine translation platform";
    homepage = "https://www.apertium.org/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
