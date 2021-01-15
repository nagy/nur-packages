{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, gumbo, boost }:
stdenv.mkDerivation rec {
  pname = "gumbo-gq";
  version = "dev";

  src = fetchFromGitHub {
    # owner = "TechnikEmpire";
    owner = "TechnikEmpire"; # fork that add cmake-install and other stuff
    repo = "GQ";
    rev = "a00f4ed73064797c627887d5be7b8bee41d7223f";

    sha256 = "03bd9gipna6gwb7wzy1qpk5mmm189s9mdg0lawnk4hw8ss7hddyq";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ gumbo boost ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_SHARED_LIBS=TRUE"
  ];

  meta = with lib; {
    description = "CSS Selector Engine for Gumbo Parser";
    homepage = "https://github.com/nagy/GQ";
    license = licenses.mit;
    maintainers = [  ];
    platforms = platforms.linux;
  };
}
