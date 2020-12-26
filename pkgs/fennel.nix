{ stdenv, luaPackages, fetchFromGitHub, makeWrapper }:

let
  inherit (luaPackages) lua buildLuaPackage;
in buildLuaPackage rec {
  name = "fennel";
  version = "0.7.0";
  src = builtins.fetchurl {
    url = "https://fennel-lang.org/downloads/fennel-${version}";
    sha256 = "1j521x3qqxvrfard26abb1hpvfh9y245ha0kn4hz0cpmyqsw92q6";
  };
  unpackPhase = "true";
  buildPhase = "true";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dp $src $out/lib/lua/${lua.luaversion}/fennel.lua

    install -D $src $out/bin/fennel
    wrapProgram $out/bin/fennel \
      --prefix LUA_PATH ";" "$out/lib/lua/${lua.luaversion}/?.lua"
  '';

  meta = with stdenv.lib; {
    description = "Fennel (formerly fnl) is a lisp that compiles to Lua";
    homepage = https://fennel-lang.org/;
    license = licenses.mit;
  };
}
