{ pkgs ? import <nixpkgs> {}  }:
{
  hyperspec = pkgs.callPackage ./pkgs/hyperspec { } ;

  luaPackages.fennel = pkgs.callPackage ./pkgs/fennel.nix { } ;

  luaPackages.tl = pkgs.callPackage ./pkgs/teal.nix { } ;

  schemaorg = pkgs.callPackage ./pkgs/schemaorg { } ;
}
