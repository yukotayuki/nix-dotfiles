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

  outputs = inputs: with inputs;
    let
      username = "joo";

      homeDirectoryPrefix = pkgs:
        if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";

      mkHomeConfig =
        { system ? "x86_64-linux"
        , pkgs ? (import nixpkgs { inherit system; })
        , homeDirectory ? "${homeDirectoryPrefix pkgs}/${username}"
        # ホスト固有の設定ファイルを受け取る。
        # ホストが増えても flake.nix を肥大化させずに差分を管理できる。
        , extraModules ? []
        # nixpkgs の openssh を使うか（FIDO2 対応が必要なホストのみ true）
        , useNixOpenssh ? true
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { isNixOS = false; inherit useNixOpenssh; };

          modules = [
            ./home.nix
            {
              home = {
                inherit username;
                inherit homeDirectory;
              };
            }
          ] ++ extraModules;
        };

      mkNixOSConfig = { system ? "x86_64-linux", extraModules }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."${username}" = import ./home.nix;
                extraSpecialArgs = { isNixOS = true; };
              };
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
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                # 初回 activation 時に home-manager が管理したいファイル
                # （.zshrc, .config/git/ignore など）が既存の場合、
                # abort せずに <file>.bak へ退避してから上書きする。
                backupFileExtension = "bak";
                users."${username}" = import ./home.nix;
                extraSpecialArgs = { isNixOS = false; };
              };
            }
          ] ++ extraModules;
        };
    in
    {
      homeConfigurations = {
        "hm-darwin@arm" = mkHomeConfig {
          system = "aarch64-darwin";
          extraModules = [ ./hosts/macos/home-configuration.nix ];
          # macOS 標準の SSH を優先（FIDO2 不要）
          useNixOpenssh = false;
        };
        hm-darwin = mkHomeConfig {
          system = "x86_64-darwin";
        };
        "hm-linux@arm" = mkHomeConfig {
          system = "aarch64-linux";
        };
        hm-linux = mkHomeConfig {};
        hm-ubuntu = mkHomeConfig {
          system = "x86_64-linux";
          extraModules = [ ./hosts/ubuntu/home-configuration.nix ];
        };
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
