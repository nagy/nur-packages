{ stdenv, fetchFromGitHub, autoconf, automake, libtool, libxml2, libxslt
, pkg-config, flex, pcre, pcre-cpp }:
stdenv.mkDerivation rec {
  pname = "lttoolbox";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "apertium";
    repo = "lttoolbox";
    rev = "v${version}";
    sha256 = "1fybcfwmwnddldkmzrqivdjymw1gajw7zsw6c0m21dhfgq9f1l6l";
  };

  buildInputs = [ autoconf automake libtool libxml2 libxslt flex pkg-config pcre pcre-cpp ];

  preConfigure= ''
    ./autogen.sh
  '';


  meta = {
    description = "Finite state compiler, processor and helper tools used by apertium";
    homepage = "https://github.com/apertium/lttoolbox";

    license = stdenv.lib.licenses.gpl2;
    maintainers = [  ];
    platforms = stdenv.lib.platforms.linux;
  };
}