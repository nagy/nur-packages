{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "cppreference";
  version = "20190607";

  src = fetchurl {
    url = "https://upload.cppreference.com/mwiki/images/1/16/html_book_${version}.tar.xz";
    sha256 = "0va81rggdfiqrzgqfn87ld8shnp9lbqqbmr2w2i4iis9lyxb55wg";

  };

  installPhase = ''
      mkdir -p "$out/share/cppreference/"
      cp -r ./ "$out/share/cppreference/"
  '';

  meta = {
    description = "cppreference";
    homepage = "https://cppreference.com/";
  };

}
