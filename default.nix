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

  lib =
    let
      filelist = lib.filesystem.listFilesRecursive ./lib;
      newSet = lib.foldr lib.recursiveUpdate { } (map (x: import x { inherit pkgs; }) filelist);
      final = newSet;
    in
    final
  # or:
  # lib.extend (final: prev: newSet);
  ;

  modules = lib.packagesFromDirectoryRecursive {
    directory = ./modules;
    callPackage = (x: _a: import x);
  };

  qemuImages = pkgs.recurseIntoAttrs (callPackage ./pkgs/qemu-images { });

  python3Packages = lib.makeScope pkgs.python3Packages.newScope (
    self:
    (lib.packagesFromDirectoryRecursive {
      directory = ./pkgs/python3-packages;
      callPackage = self.callPackage;
    })
  );

  lispPackages = pkgs.recurseIntoAttrs { cl-raylib = pkgs.callPackage ./pkgs/cl-raylib { }; };

  emacsPackages = lib.packagesFromDirectoryRecursive {
    directory = ./pkgs/emacs-packages;
    callPackage = pkgs.emacs.pkgs.callPackage;
  };
}
