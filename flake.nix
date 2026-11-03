{
  description = "Advent of Code 2025 in Goose";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # The Goose compiler, built from source. `nix flake update goose-src` bumps it.
    goose-src = {
      url = "github:aardappel/goose";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, goose-src }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        goose = pkgs.stdenv.mkDerivation {
          pname = "goose";
          version = goose-src.shortRev or "dirty";
          src = goose-src;

          nativeBuildInputs = [ pkgs.cmake pkgs.ninja ];

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
            "-DGOOSE_VERSION=${goose-src.shortRev or "dirty"}"
          ];

          # The upstream CMake has no install rules. goose finds `tcclib/`
          # beside its executable and `stdlib/` in a parent directory.
          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            cp goose $out/bin/goose
            cp -r tcclib $out/bin/tcclib
            cp -r $src/stdlib $out/stdlib
            runHook postInstall
          '';

          meta = {
            description = "A memory-safe systems language with no heap";
            homepage = "https://github.com/aardappel/goose";
            mainProgram = "goose";
          };
        };
      in
      {
        packages.goose = goose;
        packages.default = goose;

        devShells.default = pkgs.mkShell {
          packages = [
            goose
            pkgs.just
            pkgs.curl
            pkgs.pandoc # turns the puzzle page into problem.txt
            pkgs.diffutils
            pkgs.hyperfine # `just bench`
            pkgs.watchexec # `just watch`
          ];
          # `goose build` uses the stdenv C compiler that mkShell provides.
          shellHook = ''
            echo "AoC 2025 / goose $(goose version 2>/dev/null | head -1)"
            echo "run 'just' to list the recipes"
          '';
        };
      });
}
