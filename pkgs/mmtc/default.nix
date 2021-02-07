{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mmtc";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "02gvic8prpxhdbv68aw0ppaparvp23qfh0s2ydmmxia646xdj0ww";
  };

  cargoSha256 = "1wkhckyj8jj7qi14x76hphws9d8i2nvp0vmnajzlg2znk59xdl42";

  meta = with lib; {
    description = "Minimal mpd terminal client that aims to be simple yet highly configurable";
    homepage = "https://github.com/figsoda/mmtc";
    license = licenses.mpl20;
    maintainers = [ ];
    changelog = "https://raw.githubusercontent.com/figsoda/mmtc/v${version}/CHANGELOG.md";
  };
}
