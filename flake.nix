{
  description = "Bush's nix-darwin config";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixos-hardware, ... }: {
    darwinConfigurations."glaceon" = nix-darwin.lib.darwinSystem {
      modules = [
        ./hosts/glaceon
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bush = import ./home/defaults/glaceon.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };

    nixosConfigurations."jolteon" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/jolteon
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bush = import ./home/defaults/jolteon.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };

    homeConfigurations."eevee" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-linux;
      modules = [
        ./home/defaults/eevee.nix
      ];
      extraSpecialArgs = {
        accent = "#b38b5f";
      };
    };
  };
}
