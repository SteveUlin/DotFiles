{
  description = "Steve's System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";

      lib = nixpkgs.lib;

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [ inputs.emacs-overlay.overlay ]
          ++ import ./packages/default.nix { inherit lib pkgs; };
      };

    in {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

      nixosConfigurations.luna = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [ ./modules/emacs.nix ./configuration.nix ];
      };
    };
}
