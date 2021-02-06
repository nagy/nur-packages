{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mmtc";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hl98cfzlg2icfqgnpqasgrk6772wsraj78hd0k8slwa5i49n61i";
  };

  cargoSha256 = "01a8nd9fvh6w556yx88z52xp9b1l9r1qfw8n8ql9bn1l3mf1lkns";

  meta = with lib; {
    description = "Minimal mpd terminal client that aims to be simple yet highly configurable";
    homepage = "https://github.com/figsoda/mmtc";
    license = licenses.mpl20;
    maintainers = [ ];
  };
}
