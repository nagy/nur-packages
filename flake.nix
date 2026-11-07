{
  description = "NUR packages of @nagy";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  inputs.treefmt-nix = {
    url = "github:numtide/treefmt-nix";
    # One nixpkgs closure, no duplicates.
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Full NUR closure.  Flake callers get it without a NIX_PATH lookup.
  inputs.nur = {
    url = "github:nix-community/NUR";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.jsonrpc-httpproxy = {
    url = "github:nagy/jsonrpc-httpproxy";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      nur,
      jsonrpc-httpproxy,
    }:
    let
      system = "x86_64-linux";
      # allowBroken: some packages here track rolling nixpkgs and depend on
      # upstream packages that nixpkgs currently marks broken.
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowBroken = true;
          allowUnfree = true;
        };
      };
      lib = pkgs.lib;

      # This repository registered as a repo inside the full NUR closure.
      nurPkgs = import nur.outPath {
        inherit pkgs;
        nurpkgs = pkgs;
        repoOverrides = {
          nagy = import ./. { inherit pkgs; };
        };
      };

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        settings.excludes = [
          # Pre-existing unformatted files.  Format one, then drop its entry.
          "lib/emacs.nix"
          "modules/htop.nix"
          "modules/nix.nix"
          "modules/shortcommands_common.nix"
          "modules/xcompose.nix"
          "pkgs/by-name/ksv/gemset.nix"
        ];
      };
    in
    {
      # NUR convention: the full attribute set that default.nix returns.
      # It carries lib, modules, python3Packages, emacsPackages, my-build-env
      # and the package sets that are not plain derivations.
      legacyPackages.${system} = import ./. {
        inherit pkgs jsonrpc-httpproxy;
        nur = nurPkgs;
      };

      # The flake schema wants derivations only. Discover the packages with
      # the same trick that default.nix uses, so no package name is listed.
      packages.${system} = lib.packagesFromDirectoryRecursive {
        directory = ./pkgs/by-name;
        callPackage = pkgs.callPackage;
      };

      # Library API for private flakes, for example a dotfiles repository.
      lib = import ./lib/nixos.nix { inherit pkgs; };

      checks.${system}.formatting = treefmtEval.config.build.check self;

      formatter.${system} = treefmtEval.config.build.wrapper;
    };
}
