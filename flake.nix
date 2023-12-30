{
  description = "Steve's System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixvim = {
      url = "path:/home/ulins/neovim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim, ... }@inputs:
    let
      system = "x86_64-linux";

      nixOverlay = final: prev: {
        nvim = nixvim.packages.${system}.default;
      };

      lib = nixpkgs.lib;

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [ nixOverlay ]
          ++ import ./packages/default.nix { inherit lib pkgs; };
      };

    in {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

      nixosConfigurations.luna = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [ ./configuration.nix ];
      };
    };
}
