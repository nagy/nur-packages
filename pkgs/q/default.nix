{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "q";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "natesales";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4CRXamqW9E3ote80DHDmdkRF+O4k+H2G4mrws4Lgd+M=";
  };

  vendorSha256 = "sha256-jBPCZ2vnI6gnRdnKkWzrh8mYwxp3Xfvyd28ZveAYZdc=";

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
