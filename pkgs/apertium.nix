{ stdenv, fetchFromGitHub, callPackage , autoconf, automake, libtool, libxml2,
libxslt , pkg-config, flex, pcre, pcre-cpp, icu }:
stdenv.mkDerivation rec {
  pname = "apertium";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "apertium";
    repo = "apertium";
    # rev = "v${version}";
    # we have to skip forward a couple of commits ahead of 3.6.3 because there
    # it shipped with the removal of internet dependencies.
    rev = "7c9a28b1ce0033c7e8d700b5076258da78870116";
    sha256 = "0lr201a2mrs6fhg5ir2x838aayl2plq7rvp4ddpv8jrqqmmk62in";
  };

  buildInputs = [ autoconf automake libtool libxml2 libxslt flex pkg-config pcre pcre-cpp icu
                  (callPackage (import ./lttoolbox.nix) {} )];

  preConfigure= ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  meta = {
    description = "A free/open-source machine translation platform";
    homepage = https://github.com/apertium/apertium;

    license = stdenv.lib.licenses.gpl2;
    maintainers = [  ];
    platforms = stdenv.lib.platforms.linux;
  };
}
