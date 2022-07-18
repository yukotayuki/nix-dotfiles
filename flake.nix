{
  description = "joo's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
              stateVersion = "22.05";
            };
          }
        ];
      };
    in
    {
      homeConfigurations."${username}@arm" = mkHomeConfig {
        system = "aarch64-linux";
      };
      homeConfigurations."${username}@x86_64" = mkHomeConfig {
        system = "x86_64-linux";
      };
    };
}
