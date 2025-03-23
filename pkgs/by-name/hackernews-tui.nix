{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  callPackage,
}:

rustPlatform.buildRustPackage rec {
  pname = "hackernews-tui";
  version = "0.13.5";

  src = fetchFromGitHub {
    owner = "aome510";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-p2MhVM+dbNiWlhvlSKdwXE37dKEaE2JCmT1Ari3b0WI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-KuqAyuU/LOFwvvfplHqq56Df4Dkr5PkUK1Fgeaq1REs=";

  passthru.tests.version = testers.testVersion {
    package =
      # a substitute for `finalAttrs.package`
      (callPackage ./hackernews-tui.nix { });
  };

  meta = with lib; {
    description = "Terminal UI to browse Hacker News";
    homepage = "https://github.com/aome510/hackernews-TUI";
    license = with licenses; [ mit ];
    mainProgram = "hackernews_tui";
  };
}
