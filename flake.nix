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

  nixConfig = {
    extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
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

    nixosConfigurations."eevee" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = inputs;
      modules = [
        nixos-hardware.nixosModules.raspberry-pi-5
        ./hosts/eevee
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bush = import ./home/defaults/eevee.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
