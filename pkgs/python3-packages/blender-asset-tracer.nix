{
  lib,
  fetchPypi,
  buildPythonApplication,
  requests,
}:

buildPythonApplication rec {
  pname = "blender-asset-tracer";
  version = "1.15";

  src = fetchPypi {
    pname = "blender_asset_tracer";
    inherit version;
    hash = "sha256-uHDGFaS1OiHOBx2RKeuC3fgtiiYtt3t8WvBG8IK9G7w=";
  };

  buildInputs = [ requests ];

  pythonImportsCheck = [ "blender_asset_tracer" ];

  meta = {
    description = "Blender Asset Tracer, a.k.a. BAT, is the replacement of BAM and blender-file";
    homepage = "https://developer.blender.org/project/profile/79/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
