{ fetchFromGitLab, makeRustPlatform, pkgs, pkg-config, alsaLib, libudev, libxcb, python3, openssl }:
let
  # rust-nightly = pkgs.latest.rustChannels.nightly.rust;
  rust-nightly = (pkgs.rustChannelOf { date = "2020-08-15"; channel = "nightly";  }).rust;
  rustPlatform = makeRustPlatform {
    cargo = rust-nightly;
    rustc = rust-nightly;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "veloren";
  version = "0.8.0";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "03y0ipbxqz3klgin56bf5a3p2j1m7h0mj6ji57k97zdd95z1cqs8";
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    alsaLib
    libudev
    libxcb
    openssl
  ];

  doCheck = false;

  cargoSha256 = "1y2zk09300c010yy3vmmhh49gy1ax072s7qir9gh2nd55knwzmcv";

  # unfortunately this needs to be specified during compilation time
  VELOREN_USERDATA = "/tmp/userdata";
  VELOREN_USERDATA_STRAGERY = "system";

}
