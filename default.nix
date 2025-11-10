{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage (
  { pkgs, stdenv }:

  stdenv.mkDerivation rec {
    pname = "nvibrant";
    version = "1.1.0";

    nativeBuildInputs = with pkgs; [
      python313
      python313Packages.meson
      python313Packages.ninja
    ];
    
    src = fetchGit {
      url = "https://github.com/Tremeschin/nvibrant.git";
      rev = "6ca9fa32b16551a39ce51a1900f62a870d7a2200";
      submodules = true;
    };

    buildPhase = ''
      meson setup --buildtype release ./build
      ninja -C ./build
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp ./build/${pname} $out/bin
    '';
  }
) {}
