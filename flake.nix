{
  description = "personal nix configs";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixos-hardware, chaotic, ... }: {
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
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/jolteon
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; isEevee = false; };
          home-manager.users.bush = import ./home/defaults/jolteon.nix;
          home-manager.backupFileExtension = "backup";
        }
        chaotic.nixosModules.default
      ];
    };

    nixosConfigurations."espeon" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/espeon
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; isEevee = false; };
          home-manager.users.bush = import ./home/defaults/espeon.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };

    homeConfigurations."bush@eevee" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };
      
      extraSpecialArgs = { 
        inherit inputs; 
        accent = "#8B4513"; 
        isEevee = true; 
      };
      
      modules = [
        ./home/defaults/eevee.nix
      ];
    };
  };
}
