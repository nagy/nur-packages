{ stdenvNoCC, lib, python3, fetchFromGitHub }:

let
  python3WithDeps = python3.withPackages (p: [ p.pyxdg p.msal p.python-gnupg ]);
in stdenvNoCC.mkDerivation rec {
  pname = "oauth2ms";
  version = "unstable-2021-07-10";

  src = fetchFromGitHub {
    owner = "harishkrupo";
    repo = "oauth2ms";
    rev = "a1ef0cabfdea57e9309095954b90134604e21c08";
    sha256 = "0dqi6n4npdrvb42r672n4sl1jl8z5lsk554fwiiihpj0faa9dx64";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 oauth2ms $out/bin/oauth2ms
    runHook postInstall
  '';

  buildInputs = [ python3WithDeps ];

  meta = with lib; {
    description =
      "A tool to fetch oauth2 tokens from the Microsoft identity endpoint.";
    inherit (src) homepage;
    license = licenses.asl20;
  };
}
