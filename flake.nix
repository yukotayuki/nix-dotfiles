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
      #username = builtins.getEnv "USER";
      username = "joo";

      # # system - argument
      # getHomeDirectory = system: with nixpkgs.legacyPackages.${system}.stdenv;
      # if isDarwin then
      #   "/Users/${username}"
      # else if isLinux then
      #   "/home/${username}"
      #   #"/${username}"
      # else "";

      mkHomeConfig = 
      let
        homeDirectoryPrefix = pkgs:
          if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
      in
      { system ? "x86_64-linux"
      , pkgs ? (self.lib.pkgsForSystem {
        inherit sytem; 
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };
      })
      , homeDirectory ? "${homeDirectoryPrefix pkgs}/${username}"
      }:
      home-manager.lib.homeManagerConfiguration {
        # pkgs = import nixpkgs {
        #   inherit system;
        #   config = {
        #     allowUnfree = true;
        #     allowUnsupportedSystem = true;
        #   };
        # };
        modules = [
          ./home.nix
          {
            home = {
              inherit username;
              inherit homeDirectory;
              # homeDirectory = getHomeDirectory args.system;
              # stateVersion = "22.05";
            };
          }
        ];
      };

      mkNixOSConfig = { system ? "x86_64-linux" , extraModules }:
      nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = import ./home.nix;
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
