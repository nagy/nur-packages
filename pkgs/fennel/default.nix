{ lib, lua53Packages, fetchurl, installShellFiles }:

with lua53Packages;
buildLuarocksPackage rec {
  pname = "fennel";
  version = "0.8.1-1";

  src = fetchurl {
    url = "mirror://luarocks/fennel-${version}.src.rock";
    sha256 = "0i10xf4y3xplphc0r10pqd8j1ia80aydmzy7961mc3x4znmlmkja";
  };

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [ lua ];

  postInstall = ''
    installManPage fennel.1
  '';

  meta = with lib; {
    description = "A lisp that compiles to Lua";
    homepage = "https://fennel-lang.org/";
    license = licenses.mit;
  };
}
