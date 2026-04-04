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
      vars = import ./vars.nix;
      inherit (vars) username homeDirectoryPrefix;

      mkHomeConfig =
        { system ? "x86_64-linux"
        , pkgs ? (import nixpkgs { inherit system; })
        , homeDirectory ? "${homeDirectoryPrefix pkgs}/${username}"
        , extraModules ? []
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

      mkDarwinConfig = { system ? "x86_64-darwin", extraModules, hmModules ? [] }:
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
                # ホスト固有の home-manager モジュール（hostSpec 設定など）
                sharedModules = hmModules;
              };
            }
          ] ++ extraModules;
        };
    in
    {
      homeConfigurations = {
        mochi = mkHomeConfig {
          system = "aarch64-darwin";
          extraModules = [
            ./modules/hostSpec.nix
            ./hosts/mochi/home-configuration.nix
            { hostSpec.name = "mochi"; }
          ];
        };
        canele = mkHomeConfig {
          system = "x86_64-linux";
          extraModules = [
            ./modules/hostSpec.nix
            ./hosts/canele/home-configuration.nix
            { hostSpec.name = "canele"; }
          ];
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
        kinako = mkDarwinConfig {
          system = "aarch64-darwin";
          extraModules = [ ./hosts/kinako/darwin-configuration.nix ];
          hmModules = [
            ./modules/hostSpec.nix
            ./hosts/kinako/home-configuration.nix
            { hostSpec.name = "kinako"; hostSpec.enableYubikey = true; }
          ];
        };
      };

      apps = {
        "aarch64-darwin" =
          let
            pkgs = import nixpkgs { system = "aarch64-darwin"; };
            git = "${pkgs.git}/bin/git";
          in
          {
            "setup-kinako" = {
              type = "app";
              program = "${pkgs.writeShellScript "setup-kinako" ''
                set -euo pipefail
                DOTFILES_DIR="$HOME/dotfiles"
                if [ ! -d "$DOTFILES_DIR/.git" ]; then
                  ${git} clone "git@github.com:yukotayuki/nix-dotfiles.git" "$DOTFILES_DIR" 2>/dev/null \
                    || ${git} clone "https://github.com/yukotayuki/nix-dotfiles" "$DOTFILES_DIR"
                fi
                nix run nix-darwin -- switch --flake "$DOTFILES_DIR#kinako"
              ''}";
            };
            "setup-mochi" = {
              type = "app";
              program = "${pkgs.writeShellScript "setup-mochi" ''
                set -euo pipefail
                DOTFILES_DIR="$HOME/dotfiles"
                if [ ! -d "$DOTFILES_DIR/.git" ]; then
                  ${git} clone "git@github.com:yukotayuki/nix-dotfiles.git" "$DOTFILES_DIR" 2>/dev/null \
                    || ${git} clone "https://github.com/yukotayuki/nix-dotfiles" "$DOTFILES_DIR"
                fi
                nix run home-manager -- switch --flake "$DOTFILES_DIR#mochi" -b bak
                brew bundle --file "$DOTFILES_DIR/Brewfile"
              ''}";
            };
          };
        "x86_64-linux" =
          let
            pkgs = import nixpkgs { system = "x86_64-linux"; };
            git = "${pkgs.git}/bin/git";
          in
          {
            "setup-canele" = {
              type = "app";
              program = "${pkgs.writeShellScript "setup-canele" ''
                set -euo pipefail
                DOTFILES_DIR="$HOME/dotfiles"
                if [ ! -d "$DOTFILES_DIR/.git" ]; then
                  ${git} clone "git@github.com:yukotayuki/nix-dotfiles.git" "$DOTFILES_DIR" 2>/dev/null \
                    || ${git} clone "https://github.com/yukotayuki/nix-dotfiles" "$DOTFILES_DIR"
                fi
                nix run home-manager -- switch --flake "$DOTFILES_DIR#canele" -b bak
              ''}";
            };
          };
      };
    };
}
