{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "schemaorg";
  version = "10.0";

  src = fetchFromGitHub {
    owner = "schemaorg";
    repo = "schemaorg";
    rev = "V${version}-release";
    sha256 = "15p11fq0v51rk804wwz6z48zwd9r22m470ly9qly9gpjb30x47j4";
  };

  installPhase = ''
    mkdir -p "$out/share/schema.org/"
    cp -r "data/releases/${version}/" "$out/share/schema.org/"
  '';

  meta = {
    description = "schema.org";
    homepage = "schema.org";
  };
}
