{ pkgs, lib, callPackage }:

lib.foldr lib.recursiveUpdate { } [
  (import ./import.nix { inherit pkgs lib; })
  (import ./convert.nix { inherit pkgs lib callPackage; })
  (import ./cargoIndex.nix { inherit pkgs lib; })
  (import ./emacs.nix { inherit pkgs lib; })
  (import ./npm-package.nix { inherit pkgs lib callPackage; })
]
