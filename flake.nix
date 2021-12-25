{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs, nur }: rec {
    packages.x86_64-linux = import self {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    };
  };
}
