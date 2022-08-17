{ lib, fetchFromGitHub, buildPythonPackage, setuptools_scm, pymatting
, filetype, scikitimage, installShellFiles, pillow
, flask
, tqdm
, waitress
, requests
, fastapi
, gdown
, numpy
, uvicorn
, flatbuffers
, asyncer
, onnxruntime
, coloredlogs
, sympy
, pytorch, torchvision }:

buildPythonPackage rec {
  pname = "rembg";
  version = "2.0.21";

  src = fetchFromGitHub {
    owner = "danielgatis";
    repo = "rembg";
    rev = "v${version}";
    sha256 = "sha256-/xYl3uB80skRYv2dS0d2HjSIPYq/sjfWM6QReSXVBaI=";
  };

  pythonImportsCheck = [ "rembg" ];

  doCheck = false;

  nativeBuildInputs = [ setuptools_scm installShellFiles ];

  prePatch = ''
    substituteInPlace requirements-gpu.txt --replace "==" ">="
    substituteInPlace requirements.txt \
       --replace numpy==1.22.3        numpy==1.23.1 \
       --replace scikit-image==0.19.1 scikit-image==0.18.3
    substituteInPlace requirements.txt --replace "==" ">="
    substituteInPlace setup.py --replace "~=" ">="
    # remove warning for newer pythons
    substituteInPlace rembg/__init__.py --replace "and sys.version_info.minor == 9" ""
  '';

  # to fix failing imports check
  preBuild = ''
    export NUMBA_CACHE_DIR=$TMPDIR
  '';

  propagatedBuildInputs = [
    pymatting
    filetype
    scikitimage
    pytorch
    torchvision

    requests
    flask
    tqdm
    waitress
    fastapi
    gdown
    pillow
    numpy
    uvicorn
    asyncer

    onnxruntime
    flatbuffers
    sympy
    coloredlogs
  ];

  meta = with lib; {
    description = "Tool to remove images background";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
