{ stdenv, luaPackages, fetchFromGitHub, makeWrapper }:

let
  inherit (luaPackages) lua buildLuaPackage;
in buildLuaPackage rec {
  name = "teal";
  version = "0.7.1";
  src = builtins.fetchurl {
    url = "https://teal-lang.org/downloads/teal-${version}";
    sha256 = "01f0xfp9g5z6jhdr006n15bnn0rlcfdbgiilamqgkhx28gnjrswf";
  };
  unpackPhase = "true";
  buildPhase = "true";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dp $src $out/lib/lua/${lua.luaversion}/teal.lua

    install -D $src $out/bin/teal
    wrapProgram $out/bin/teal \
      --prefix LUA_PATH ";" "$out/lib/lua/${lua.luaversion}/?.lua"
  '';

  meta = with stdenv.lib; {
    description = "teal is a lua that compiles to Lua";
    homepage = https://teal-lang.org/;
    license = licenses.mit;
  };
}
