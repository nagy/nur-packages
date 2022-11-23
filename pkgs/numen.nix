{ lib, fetchFromSourcehut, buildGoModule, vosk-api }:

buildGoModule rec {
  pname = "numen";
  version = "0.3";

  src = fetchFromSourcehut {
    owner = "~geb";
    repo = pname;
    rev = version;
    sha256 = "sha256-fz+EKXF5oZJrXGxO30aSdhshO70zAx7kRrTlloKsn4A=";
  };

  buildInputs = [ vosk-api ];

  vendorSha256 = "sha256-7BQDzMuis6g8rsf2WJvAResn4iQjUPdTBSskWhepeNc=";

  postBuild = ''
    go build speech.go
  '';

  postInstall = ''
    install -Dm755 numen $out/bin/numen2
    patchShebangs speech scribe instructor record
    install -Dm755 -t $out/libexec speech scribe instructor record
    install -Dm755 -t $out/libexec/handlers handlers/*
  '';

  meta = with lib; {
    description = "Voice control for handsfree computing";
    homepage = "https://numenvoice.com/";
    license = with licenses; [ gpl3Only ];
  };
}
