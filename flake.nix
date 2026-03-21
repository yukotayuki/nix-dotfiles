{
  description = "joo's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs: with inputs;
    let
      username = "joo";

      homeDirectoryPrefix = pkgs:
        if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";

      mkHomeConfig =
        { system ? "x86_64-linux"
        , pkgs ? (import nixpkgs { inherit system; })
        , homeDirectory ? "${homeDirectoryPrefix pkgs}/${username}"
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { isNixOS = false; };

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

      mkNixOSConfig = { system ? "x86_64-linux", extraModules }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${username}" = import ./home.nix;
              home-manager.extraSpecialArgs = { isNixOS = true; };
            }
          ] ++ extraModules;
        };

      mkDarwinConfig = { system ? "x86_64-darwin", extraModules }:
        darwin.lib.darwinSystem {
          inherit system;
          modules = [
            home-manager.darwinModules.home-manager
            {
              # home-manager の nixos/common.nix は home.homeDirectory を
              # users.users.<name>.home から導出する。未設定だと null になり
              # ビルド時に `absolute path` 型チェックで失敗する。
              # home.nix 側で設定しない理由:
              #   home.nix は standalone / darwin で共用しているため、
              #   darwin 固有のパスはここで設定する方が責務が明確。
              users.users."${username}".home = "/Users/${username}";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # 初回 activation 時に home-manager が管理したいファイル
              # （.zshrc, .config/git/ignore など）が既存の場合、
              # abort せずに <file>.bak へ退避してから上書きする。
              home-manager.backupFileExtension = "bak";
              home-manager.users."${username}" = import ./home.nix;
              home-manager.extraSpecialArgs = { isNixOS = false; };
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
