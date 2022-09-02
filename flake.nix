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

      # system - argument
      getHomeDirectory = system: with nixpkgs.legacyPackages.${system}.stdenv;
        if isDarwin then
          "/Users/${username}"
        else if isLinux then
          "/home/${username}"
          #"/${username}"
        else "";
      
      mkHomeConfig = args: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit (args) system;
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        };
        modules = [
          ./home.nix
          {
            home = {
              inherit username;
              homeDirectory = getHomeDirectory args.system;
              # stateVersion = "22.05";
            };
          }
        ];
      };

      mkNixOSConfig = args: nixpkgs.lib.nixosSystem {
        inherit (args) system;
        modules = [
          args.configuration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = import ./home.nix;
          }
        ];
      };

      # mkNixOSGaming = args: nixpkgs.lib.nixosSystem {
      #   inherit (args) system;
      #   modules = [
      #     ./host/gaming/configuration.nix
      #     home-manager.nixosModules.home-manager
      #     {
      #       home-manager.useGlobalPkgs = true;
      #       home-manager.useUserPackages = true;
      #       home-manager.users."${username}" = import ./home.nix;
      #     }
      #   ];
      # };

      mkDarwinConfig = args: darwin.lib.darwinSystem {
        inherit (args) system;
        specialArgs = {
          inherit (args) machine;
        };
        modules = [
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = import ./home.nix;
          }
        ];
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
        hm-linux = mkHomeConfig {
          system = "x86_64-linux";
        };
      };

      nixosConfigurations = {
        nix-laptop = mkNixOSConfig {
          system = "x86_64-linux";
          configuration = ./host/laptop/configuration.nix;
        };
        nix-gaming = mkNixOSConfig {
          system = "x86_64-linux";
          configuration = ./host/gaming/configuration.nix;
        };
      };

      darwinConfigurations."${username}-mbp" = mkDarwinConfig {
        system = "aarch64-darwin";
        machine = "joo-mbp";
      };
    };
}
