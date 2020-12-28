{ pkgs ? import <nixpkgs> {}  }:
{
  hyperspec = pkgs.callPackage ./pkgs/hyperspec { } ;

  luaPackages = pkgs.recurseIntoAttrs {

    fennel = pkgs.callPackage ./pkgs/fennel.nix { } ;
    tl = pkgs.callPackage ./pkgs/teal.nix { } ;

  };

  schemaorg = pkgs.callPackage ./pkgs/schemaorg { } ;

  passphrase2pgp = pkgs.callPackage ./pkgs/passphrase2pgp.nix {};

  apertium = pkgs.callPackage ./pkgs/apertium.nix {};

  lttoolbox = pkgs.callPackage ./pkgs/lttoolbox.nix {};

  ruffle = pkgs.callPackage ./pkgs/ruffle {};

  lunasvg = pkgs.callPackage ./pkgs/lunasvg.nix {};

  lispPackages = pkgs.recurseIntoAttrs {
    vacietis = pkgs.callPackage ./pkgs/vacietis {};
  };

}
