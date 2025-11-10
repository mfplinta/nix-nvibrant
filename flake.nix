{
  description = "nvibrant flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      createPackage = import ./default.nix;
      createModule = import ./module.nix;

      supportedSystems = [ "x86_64-linux" ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (
        system: f nixpkgs.legacyPackages.${system}
      );
    in {
      nixosModules = rec {
        nix-nvibrant = createModule { };
        default = nix-nvibrant;
      };

      homeModules = rec {
        nix-nvibrant = createModule { isHomeModule = true; };
        default = nix-nvibrant;
      };

      packages = forAllSystems (pkgs: rec {
        nvibrant = createPackage { inherit pkgs; };
        default = nvibrant;
      });

      overlays.default = (final: _: {
        nvibrant = createPackage { pkgs = final; };
      });

      formatter = forAllSystems (pkgs: pkgs.alejandra);
    };
}
