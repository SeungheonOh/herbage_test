{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    herbage.url = "github:seungheonoh/herbage";
  };

  outputs = inputs@{ flake-parts, nixpkgs, herbage, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];

      systems =
        [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      perSystem = { config, system, inputs', self', ... }:
        let
          pkgs = import inputs.nixpkgs { inherit system; };
          herbage = inputs.herbage.lib { inherit system pkgs; };

        in {
          packages.hackage = herbage.genHackage ./my-private-keys
            (import ./sources.nix { inherit pkgs; });
        };
    };
}
