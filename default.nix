{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  callPackage ? pkgs.callPackage,
}:

# The main packages
(lib.packagesFromDirectoryRecursive {
  directory = ./pkgs/by-name;
  callPackage = callPackage;
})
# Extras
// {

  lib = lib.extend (
    final: prev:
    # this extra callPackage call is needed to give
    # the result an `override` ability.
    (callPackage ./lib { })
  );

  modules = lib.mapAttrs' (
    filename: _filetype:
    lib.nameValuePair "${lib.removeSuffix ".nix" filename}" ((import (./modules + "/${filename}")))
  ) (builtins.readDir ./modules);

  qemuImages = pkgs.recurseIntoAttrs (callPackage ./pkgs/qemu-images { });

  python3Packages = pkgs.recurseIntoAttrs (
    lib.makeScope pkgs.python3Packages.newScope (
      self:
      import ./pkgs/python3-packages {
        inherit (self) callPackage;
        lib = lib;
      }
    )
  );

  lispPackages = pkgs.recurseIntoAttrs { cl-raylib = pkgs.callPackage ./pkgs/cl-raylib { }; };
}
