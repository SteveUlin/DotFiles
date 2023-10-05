{
  inputs = {
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim, ... }: {
    nixosConfigurations.luna = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixvim.nixosModules.nixvim
        ./configuration.nix
      ];
    };
  };
}
