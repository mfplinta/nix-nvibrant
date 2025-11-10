[nvibrantRepo]: https://github.com/Tremeschin/nvibrant
[nvibrantUsage]: https://github.com/Tremeschin/nvibrant?tab=readme-ov-file#-usage

<!---->

# nix-nvibrant

A lightweight flake providing a nixpkgs overlay and Home Manager/NixOS modules
for [nvibrant][nvibrantRepo].

## Installation

Add this repo to your flake's inputs and include the overlay to add `nvibrant`
to nixpkgs, like so:

```nix
# flake.nix

{
  # ...

  inputs = {
    # ...

    nvibrant = {
      url = "github:mikaeladev/nix-nvibrant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, nvibrant, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nvibrant.overlays.default ];
      };
    in
    {
      # for NixOS, use `pkgs` instead of `nixpkgs` to get the overlay
      nixosConfigurations = pkgs.lib.nixosSystem {
        # ...
      };

      # for standalone home-manager, override the `pkgs` attribute
      homeConfigurations.yourname = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # ...
      };
    }
}
```

## Usage

> [!NOTE]
> This section explains how to use the nvibrant service, not nvibrant itself
> (see [nvibrant's README][nvibrantUsage] instead).

Add the following to your nix config:

```nix
# nvibrant.nix
{ inputs, ... }: {
  # use the other import for NixOS configs
  imports = [
    inputs.nvibrant.homeModules.default
    # inputs.nvibrant.nixosModules.default
  ];

  services.nvibrant = {
    # toggles the service on/off
    enable = true;

    # sets the vibrancy level for each output
    arguments = [
      "-1024" # greyscale
      "1023" # +200% saturation
      # ...
    ];
  };
}
```

## License

This project is licensed under the terms of the GNU General Public License 3.0.
You can read the full license text in [LICENSE](./LICENSE).
