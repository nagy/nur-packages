{ stdenv, fetchFromGitHub, cmake, boost, callPackage,
  glm, openscenegraph, nlohmann_json, libglvnd, catch2, ois }:

stdenv.mkDerivation rec {
  pname = "skybolt";
  version = "git";

  src = fetchFromGitHub {
    owner = "Piraxus";
    repo = pname;
    rev = "b81547fdcfe68f1864de749345e1ba8e3898d358";
    sha256 = "1z22n4mz8jj3nwn2qqndr9dfn28zym0yah8brz69i5w1nq5zjnl1";
  };

  preConfigure = ''
      sed -i 's/json/nlohmann_json/g' src/Skybolt/SkyboltCommon/CMakeLists.txt
      sed -i '23d' src/Skybolt/SkyboltCommon/CMakeLists.txt
      sed -i '23d' src/Skybolt/SkyboltCommon/CMakeLists.txt
      sed -i 's/(catch/(Catch2/g' src/Skybolt/SkyboltCommonTests/CMakeLists.txt
      sed -i '9d' src/Skybolt/SkyboltCommonTests/CMakeLists.txt
      sed -i '9d' src/Skybolt/SkyboltCommonTests/CMakeLists.txt
      sed -i '10d' src/Skybolt/SkyboltVis/CMakeLists.txt
      sed -i '14d' src/Skybolt/SkyboltVis/CMakeLists.txt
      sed -i '14d' src/Skybolt/SkyboltVis/CMakeLists.txt
      sed -i '15d' src/Skybolt/SkyboltVis/CMakeLists.txt

      sed -i '73d' CMakeLists.txt
      sed -i '73d' CMakeLists.txt
      sed -i '73d' CMakeLists.txt
      sed -i '73d' CMakeLists.txt

      sed -i 's/(catch/(Catch2/g' src/Skybolt/SkyboltEngineTests/CMakeLists.txt
      sed -i 's/(catch/(Catch2/g' src/Skybolt/SkyboltVisTests/CMakeLists.txt
      sed -i 's/(catch/(Catch2/g' src/Skybolt/SkyboltSimTests/CMakeLists.txt
      cat <<EOF > CMake/SkyboltInstall.cmake
      macro(skybolt_install target)
      endmacro()

      macro(skybolt_plugin_install target)
      endmacro()
      EOF
    '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DOIS_INCLUDE_DIR=$ois/include"
  ];

  buildInputs = [ boost glm openscenegraph nlohmann_json catch2
                  libglvnd ois cxxtimer px cpp-httplib earcut];

  meta = with lib; {
    description = "Rendering engine and aerospace simulation tools";
    homepage = "https://github.com/Piraxus/skybolt";

    license = licenses.mpl20;
    maintainers = [  ];
    platforms = platforms.linux;
  };
}
