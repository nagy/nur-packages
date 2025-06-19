{
  pkgs,
  lib ? pkgs.lib,
  ...
}:

rec {
  cargoCratesIoRegistryGit = pkgs.fetchgit {
    url = "https://github.com/rust-lang/crates.io-index";
    rev = "0c42b451acc49c280588f01dd599af738f485664";
    hash = "sha256-eedG6VoOzcsRVvoLfGrTD8vDjseOxouw56iKUY2FDNk=";
  };

  cargoCratesIoRegistry = pkgs.linkFarm "crates.io-index" [
    {
      name = "index";
      path = cargoCratesIoRegistryGit;
    }
  ];

  cargoConfigWithLocalRegistry = pkgs.writeTextFile {
    name = "cargo_config";
    destination = "/.cargo/config.toml";
    text = ''
      [source]
      [source.crates-io]
      replace-with = "local-copy"
      [source.local-copy]
      local-registry = "${cargoCratesIoRegistry}"
    '';
  };

  mkCargoLock =
    { file }:
    pkgs.runCommandLocal "Cargo.lock"
      {
        inherit file;
        nativeBuildInputs = [ pkgs.cargo ];
      }
      ''
        mkdir src .cargo
        ln -s "${cargoConfigWithLocalRegistry}/.cargo/config.toml" .cargo/
        ln -s "$file" Cargo.toml
        touch src/main.rs
        cargo generate-lockfile
        mv Cargo.lock $out
      '';

  mkCargoDoc =
    {
      name,
      version ? "*",
    }:

    pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = "cargo-doc-${name}";
      version = "0-unstable";

      src = pkgs.emptyDirectory;

      nativeBuildInputs = [
        pkgs.rustPlatform.cargoSetupHook
        pkgs.rustc
        pkgs.cargo
      ];

      cargotoml = pkgs.writeText "Cargo.toml" ''
        [package]
        name = "nix-build"
        version = "0.0.1"
        edition = "2024"

        [dependencies]
        ${name} = "${version}"
      '';

      buildPhase = ''
        runHook preBuild

        ln -s $cargotoml Cargo.toml
        mkdir src
        touch src/main.rs
        cargo doc --no-deps --package "${name}" --offline

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mv target/doc $out

        runHook postInstall
      '';

      cargoDeps = pkgs.rustPlatform.importCargoLock {
        lockFile = mkCargoLock { file = finalAttrs.cargotoml; };
      };

      postPatch = ''
        ln -s $cargoDeps/Cargo.lock
      '';
    });
}
