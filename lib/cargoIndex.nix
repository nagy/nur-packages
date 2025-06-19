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

  mkRustScriptDir =
    {
      file,
      pname ? "main",
    }:
    pkgs.runCommandLocal "rust-script"
      {
        inherit file pname;
        nativeBuildInputs = [
          pkgs.rust-script
          pkgs.cargo
        ];
        CARGO_HOME = "/tmp/cargo";
      }
      ''
        mkdir /tmp/cargo $out
        ln -s ${cargoConfigWithLocalRegistry}/.cargo/config.toml /tmp/cargo/
        cp -v -- $file $pname.rs
        rust-script --cargo-output --package --pkg-path . $pname.rs
        sed -i Cargo.toml -e 's,^name = .*,name = "${pname}",g'
        sed -i Cargo.toml -e 's,^path = .*,path = "${pname}.rs",g'
        cargo generate-lockfile
        mv Cargo.* $pname.rs $out/
      '';

  mkRustScript =
    {
      file,
      name ? lib.removeSuffix ".rs" (builtins.baseNameOf file),
    }:
    pkgs.rustPlatform.buildRustPackage rec {
      inherit name;
      src = mkRustScriptDir {
        inherit file;
        pname = name;
      };
      lockFile = src + "/Cargo.lock";
      postPatch = ''
        cp $lockFile Cargo.lock
      '';
      cargoLock = { inherit lockFile; };
      doCheck = false; # dunno
    };

  mkCargoWatcher =
    {
      file,
      pname ? "main",
    }:
    pkgs.writeShellScriptBin "cargo-watcher" ''
      ln -fs ${mkRustScriptDir { inherit file pname; }}/Cargo.toml
      ln -fs ${mkRustScriptDir { inherit file pname; }}/Cargo.lock
      PATH=${pkgs.cargo-watch}/bin/:${pkgs.cargo}/bin/:${pkgs.gcc}/bin:$PATH \
        CARGO_TARGET_DIR=/tmp/cargotarget \
        ${pkgs.cargo}/bin/cargo watch "$@"
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
