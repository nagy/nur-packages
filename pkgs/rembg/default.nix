{ pkgs, lib, fetchurl, fetchFromGitHub, buildPythonPackage, setuptools-scm
, pymatting, filetype, scikitimage, installShellFiles, pillow, flask, tqdm
, waitress, requests, fastapi, gdown, numpy, uvicorn, flatbuffers, asyncer
, onnxruntime, coloredlogs, sympy, opencv4, requireFile, runCommandLocal
, makeWrapper, rembg, pooch, symlinkJoin, imagehash, testers }:

let
  models = lib.mapAttrsToList (name: hash:
    fetchurl {
      inherit name hash;
      url =
        "https://github.com/danielgatis/rembg/releases/download/v0.0.0/${name}.onnx";
    }) {
      u2net = "sha256-jRDS87t1rjttUnx3lE/F59zZSymAnUenOaenKKkStJE="; # 168MB
      u2netp = "sha256-MJyEaSWN2nQnk9zg6+qObdOTF0+Jk0cz7MixTHb03dg="; # 4MB
      u2net_human_seg =
        "sha256-AetqKaXE2O2zC1atrZuzoqBTUzjkgHJKIT4Kz9LRxzw="; # human segment 168MB
      u2net_cloth_seg =
        "sha256-bSy8J7+9yYnh/TJWVtZZAuzGo8y+lLLTZV7BFO/LEo4="; # cloth segment 168MB
      silueta = "sha256-ddpsjS+Alux0PQcZUb5ztKi8ez5R2aZiXWNkT5D/7ts="; # 42MB
    };
  U2NET_HOME = symlinkJoin {
    name = "u2net-home";
    paths = map (x:
      runCommandLocal "u2net_home" { }
      "mkdir $out && ln -s ${x} $out/${x.name}.onnx ") models;
  };
in buildPythonPackage rec {
  pname = "rembg";
  version = "2.0.31";

  src = fetchFromGitHub {
    owner = "danielgatis";
    repo = "rembg";
    rev = "v${version}";
    sha256 = "sha256-0zUyWCmd9XGQXRoO6P95tqkBzPmXerp5rsm6LV2pn0w=";
  };

  nativeBuildInputs = [ setuptools-scm installShellFiles ];

  # pythonRelaxDeps = true;

  prePatch = ''
    substituteInPlace setup.py \
      --replace "opencv-python-headless>=4.6.0.66" "opencv"
    substituteInPlace requirements.txt \
      --replace "opencv-python-headless==4.6.0.66" "opencv"
  '';

  propagatedBuildInputs = [
    pymatting
    filetype
    scikitimage
    # pytorch
    # torchvision

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
    opencv4
    pooch
    imagehash
  ];

  makeWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${pkgs.onnxruntime}/lib "
    "--set U2NET_HOME ${U2NET_HOME}"
  ];

  # to fix failing imports check
  preInstallCheck = ''
    export NUMBA_CACHE_DIR=$TMPDIR
  '';

  pythonImportsCheck = [ "rembg" ];

  passthru.tests.version =
    (testers.testVersion { package = rembg; }).overrideAttrs
    (_: { NUMBA_CACHE_DIR = "/tmp"; });

  meta = with lib; {
    description = "Tool to remove images background";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
