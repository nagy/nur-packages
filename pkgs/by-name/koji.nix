{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  stdenv,
  darwin,
  testers,
  koji,
}:

rustPlatform.buildRustPackage rec {
  pname = "koji";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "cococonscious";
    repo = "koji";
    rev = "v${version}";
    hash = "sha256-+xtq4btFbOfiyFMDHXo6riSBMhAwTLQFuE91MUHtg5Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WiFXDXLJc2ictv29UoRFRpIpAqeJlEBEOvThXhLXLJA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  doCheck = false;
  passthru.tests.version = testers.testVersion { package = koji; };

  meta = {
    description = "An interactive CLI for creating conventional commits";
    homepage = "https://github.com/its-danny/koji";
    changelog = "https://github.com/its-danny/koji/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nagy ];
  };
}
