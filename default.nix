{ pkgs ? import <nixpkgs> {}  }:
{
  hyperspec = pkgs.callPackage ./pkgs/hyperspec { } ;
}
