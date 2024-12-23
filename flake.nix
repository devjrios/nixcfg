{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-cfg = {
      url = "github:devjrios/nixvim-cfg/nixos-24.11";
      inputs.nixvim.inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixvim.inputs.home-manager.follows = "home-manager";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixvim-cfg,
    lix-module,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    chadwm-src = pkgs.fetchFromGitHub {
      owner = "siduck";
      repo = "chadwm";
      rev = "978dc36e039725838a72bcd9d266e55fa265e522";
      hash = "sha256-nV5wyw7mK6bAEBUEZzmfkjsA2AZbw1nJI8u/mihhbwY=";
    };
  in {
    formatter.${system} = pkgs.alejandra;
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs chadwm-src;};
      modules = [
        ./nixos
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jrios.imports = [./home];
          home-manager.extraSpecialArgs = {inherit inputs nixvim-cfg system chadwm-src;};
        }
        lix-module.nixosModules.default
      ];
    };
  };
}
