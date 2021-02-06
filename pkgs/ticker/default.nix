{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "ticker";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kp1wgb3bakkawr81sa7fsx8gaazica8lffvysqcp5d5kw22jirv";
  };

  vendorSha256 = "12gkwqkf7xxgc3ckra7ar6n4klykja43ya0s1j0ds3pinyrhvc5b";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    license = licenses.gpl3;
  };
}
