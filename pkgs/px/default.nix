{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "px";
  version = "git";

  src = fetchFromGitHub {
    owner = "pplux";
    repo = "px";
    rev = "b23d37e14cb42ea0078c5ff8d20de38045b3c5d1";
    sha256 = "03p0gshj7nrahnihwfkkk4ikn7a3306wrzbw33fxbdgmwgzh6v7r";
  };

  buildInputs = [ ];

  phases = [ "installPhase" ];

  installPhase = ''
     install -Dm644 $src/px_mem.h $out/include/px_mem.h
     install -Dm644 $src/px_sched.h $out/include/px_sched.h
     install -Dm644 $src/px_render.h $out/include/px_render.h
     install -Dm644 $src/px_render_gltf.h $out/include/px_render_gltf.h
     install -Dm644 $src/px_render_imgui.h $out/include/px_render_imgui.h
  '';

  meta = with lib; {
    description = "Single header C++ Libraries for Thread Scheduling, Rendering, and so on...";
    homepage = "https://github.com/pplux/px";

    license = licenses.mit;
    maintainers = [  ];
    platforms = platforms.all;
  };
}
