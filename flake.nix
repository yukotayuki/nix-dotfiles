{
  description = "joo's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs: with inputs;
    let
      username = "joo";

      mkHomeConfig = 
      let
        isNixOS = false;
        homeDirectoryPrefix = pkgs:
          if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
      in
      { system ? "x86_64-linux"
      , pkgs ? (import nixpkgs { inherit system; })
      , homeDirectory ? "${homeDirectoryPrefix pkgs}/${username}"
      }:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit isNixOS; };

        modules = [
          ./home.nix
          {
            home = {
              inherit username;
              inherit homeDirectory;
            };
          }
        ];
      };

      mkNixOSConfig = 
      let
        isNixOS = true;
      in
      { system ? "x86_64-linux" , extraModules }:
      nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit isNixOS; };
          }
        ] ++ extraModules;
      };

      mkDarwinConfig = { system ? "x86_64-darwin", extraModules }:
      darwin.lib.darwinSystem {
        inherit system;
        # specialArgs = {
        #   inherit machine;
        # };
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = import ./home.nix;
          }
        ] ++ extraModules;
      };
    in
    {
      homeConfigurations = {
        "hm-darwin@arm" = mkHomeConfig {
          system = "aarch64-darwin";
        };
        hm-darwin = mkHomeConfig {
          system = "x86_64-darwin";
        };
        "hm-linux@arm" = mkHomeConfig {
          system = "aarch64-linux";
        };
        hm-linux = mkHomeConfig {};
      };

      nixosConfigurations = {
        nix-laptop = mkNixOSConfig {
          extraModules = [
            ./hosts/laptop/configuration.nix
          ];
        };
        nix-gaming = mkNixOSConfig {
          extraModules = [
            ./hosts/gaming/configuration.nix
          ];
        };
      };

      darwinConfigurations = {
        "darwin@arm" = mkDarwinConfig {
          system = "aarch64-darwin";
          extraModules = [
            ./hosts/macos/darwin-configuration.nix
          ];
        };
      };
    };
}
