{ pkgs ? import <nixpkgs> {}  }:
{
  hyperspec = pkgs.callPackage ./pkgs/hyperspec { } ;

  luaPackages.fennel = pkgs.callPackage ./pkgs/fennel.nix { } ;
}
