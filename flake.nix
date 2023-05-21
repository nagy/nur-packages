{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, flake-utils }:
    {
      overlays.default =
        (import self { pkgs = nixpkgs.legacyPackages."x86_64-linux"; }).overlay;
    } // (flake-utils.lib.eachDefaultSystem (system: {
      packages = flake-utils.lib.flattenTree
        (import self { pkgs = nixpkgs.legacyPackages.${system}; });
    }));
}
