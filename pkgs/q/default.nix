{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "q";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-R0xkYlzpaWwZtbxLPVyAUOe4Is2GbUCrr0jOQJnoahs=";
  };

  vendorSha256 = "sha256-onggtOs2ri4VxCPDSehkfiAf6xMjKZHKh8qeNN4tf4A=";

  subPackages = [ "." ];

  # network tests
  doCheck = false;

  meta = with lib; {
    description =
      "Tiny command line DNS client with support for UDP, TCP, DoT, DoH, DoQ and ODoH";
    homepage = "https://github.com/natesales/q";
    license = licenses.gpl3;
  };
}
