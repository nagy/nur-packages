{ pkgs ? import <nixpkgs> {}  }:
rec {
  hyperspec = pkgs.callPackage ./pkgs/hyperspec { } ;

  luaPackages = pkgs.recurseIntoAttrs {

    fennel = pkgs.callPackage ./pkgs/fennel { } ;
    tl = pkgs.callPackage ./pkgs/teal { } ;
    lua-curl = pkgs.callPackage ./pkgs/lua-curl {};

  };

  schemaorg = pkgs.callPackage ./pkgs/schemaorg { } ;

  lttoolbox = pkgs.callPackage ./pkgs/lttoolbox {};

  apertium = pkgs.callPackage ./pkgs/apertium { inherit lttoolbox; };

  lunasvg = pkgs.callPackage ./pkgs/lunasvg {};

  lispPackages = pkgs.recurseIntoAttrs {
    vacietis = pkgs.callPackage ./pkgs/vacietis {};
  };

  colorpedia = pkgs.python3Packages.callPackage ./pkgs/colorpedia {  };

  rustfilt = pkgs.callPackage ./pkgs/rustfilt {};

  warctools = pkgs.python3Packages.callPackage ./pkgs/warctools {  };

  bollux = pkgs.callPackage ./pkgs/bollux {};

  gemget = pkgs.callPackage ./pkgs/gemget {};

  cpp-httplib = pkgs.callPackage ./pkgs/cpp-httplib {};

  cxxtimer = pkgs.callPackage ./pkgs/cxxtimer {};

  cxxmatrix = pkgs.callPackage ./pkgs/cxxmatrix {};

  piecash = pkgs.python3Packages.callPackage ./pkgs/piecash { };

  hackernews-tui = pkgs.callPackage ./pkgs/hackernews-tui {};

  har-tools = pkgs.callPackage ./pkgs/har-tools {};

  ksuid = pkgs.callPackage ./pkgs/ksuid {};

  lib = {

    # A function, which adds "man" to a packages output if it is not already
    # there. This can help to separate packages man pages to make it possible to
    # only install the man page not not the package itself.
    addManOutput = pkg: pkg.overrideAttrs (old:{
      outputs = if builtins.elem "man" old.outputs then old.outputs
                else old.outputs ++ ["man"];
    });

    mkCephDocDrv = import ./lib/mk-ceph-doc-drv.nix;

  };

  ceph-doc-html = pkgs.callPackage (lib.mkCephDocDrv {}) {};
  ceph-doc-text = pkgs.callPackage (lib.mkCephDocDrv {}) { sphinx-doc-type = "text"; };
  ceph-doc-dirhtml = pkgs.callPackage (lib.mkCephDocDrv {}) { sphinx-doc-type = "dirhtml"; };

  overlays = with lib; {
    man-pages = (self: super: {
      # these packages dont have separate man-page outputs
      tor = addManOutput super.tor;
    });
  };
}
