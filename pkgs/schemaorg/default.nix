{ stdenv } :
stdenv.mkDerivation rec {
  pname = "schemaorg";
  version = "10.0";
  meta = {
    description = "schema.org";
    homepage = "schema.org";
  };
  src = builtins.fetchurl {
    url = "https://github.com/schemaorg/schemaorg/archive/V${version}-release.tar.gz";
    sha256 = "18k9py6wncka9xd14x83klb3nhkyz58hb0wggwbjp4p1rf32ydxy";
  };
  # we skip the unpackPhase
  unpackPhase = "true";
  installPhase = ''
      mkdir -p "$out/share/schema.org/"
      tar -C "$out/share/schema.org/" --strip-components=4 -xzvf $src "schemaorg-${version}-release/data/releases/${version}/"
  '';
}
